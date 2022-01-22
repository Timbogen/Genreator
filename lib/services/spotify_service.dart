import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:genreator/models/general/playlist_info_model.dart';
import 'package:genreator/models/general/track_model.dart';
import 'package:genreator/models/spotify/api_artist_model.dart';
import 'package:genreator/models/spotify/api_playlists_model.dart';
import 'package:genreator/models/spotify/api_tracks_model.dart';
import 'package:genreator/utility.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpotifyService {
  /// Factory constructor (returns the singleton instance)
  factory SpotifyService() => _instance;

  /// The singleton instance
  static final SpotifyService _instance = SpotifyService._privateConstructor();

  /// The client's permissions for usage of the spotify web api
  static const _clientScopes = [
    'ugc-image-upload',
    'user-read-recently-played',
    'user-top-read',
    'user-read-playback-position',
    'user-read-playback-state',
    'user-modify-playback-state',
    'user-read-currently-playing',
    'app-remote-control',
    'streaming',
    'playlist-modify-public',
    'playlist-modify-private',
    'playlist-read-private',
    'playlist-read-collaborative',
    'user-follow-modify',
    'user-follow-read',
    'user-library-modify',
    'user-library-read',
    'user-read-email',
    'user-read-private',
  ];

  /// The id for the liked songs 'playlist'
  static const likedSongsID = 'genreator_liked_songs';

  /// The key for the refresh token
  static const _refreshTokenKey = 'refresh_token';

  /// The key prefix for artist data
  static const _artistPrefix = 'artist_data:';

  /// Client id
  var _clientID = '';

  /// Client secret
  var _clientSecret = '';

  /// The spotify user token
  var _token = '';

  /// The playlists for the current user
  final _playlists = <String, PlaylistModel>{};

  /// Private constructor for singleton
  SpotifyService._privateConstructor() {
    try {
      _clientID = GlobalConfiguration().get('clientID');
      _clientSecret = GlobalConfiguration().get('clientSecret');
    } catch (_) {}
    if (_clientID == '' || _clientSecret == '') {
      if (kDebugMode) print('ATTENTION: Make sure to add a valid "assets/cfg/config.json"!');
    }
  }

  /// The playlists for the current user
  Map<String, PlaylistModel> get playlists {
    return _playlists;
  }

  /// Initialize the spotify service and returns true if the operation was
  /// successful. The user will be asked to authorize the app here.
  Future<bool> init() async {
    // Check whether there's a refresh token
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final refreshToken = sharedPreferences.getString(_refreshTokenKey) ?? '';

    // Get the token
    var success = false;
    if (refreshToken != "") {
      success = await getToken({'grant_type': 'refresh_token', 'refresh_token': refreshToken});
    } else {
      // Request user code
      var client = OAuth2Client(
          tokenUrl: '',
          authorizeUrl: 'https://accounts.spotify.com/authorize',
          redirectUri: 'de.weichwarenprojekt.genreator://oauth2redirect',
          customUriScheme: 'de.weichwarenprojekt.genreator');
      var authRes = await client.requestAuthorization(clientId: _clientID, scopes: _clientScopes);

      // Try to get the token
      success = await getToken({'grant_type': 'authorization_code', 'code': authRes.code ?? ''});
    }

    // Load the playlists
    if (success) await loadPlaylists();

    // Return the result
    return success;
  }

  /// Queries a user-authenticated token and returns true if the
  /// operation was successful
  Future<bool> getToken(Map<String, String> body) async {
    // Prepare the header
    var headers = <String, String>{};
    headers['Authorization'] = 'Basic ${utf8.fuse(base64).encode('$_clientID:$_clientSecret')}';
    headers['Content-Type'] = 'application/x-www-form-urlencoded';

    // Prepare the body
    body['redirect_uri'] = 'de.weichwarenprojekt.genreator://oauth2redirect';

    // Request the token
    final tokenRes = await _fetchContent(
      method: 'POST',
      url: 'https://accounts.spotify.com/api/token',
      data: body,
      headers: headers,
    );
    if (tokenRes.statusCode == 200) {
      // Get the token and save the refresh token
      _token = tokenRes.data['access_token'];
      if (tokenRes.data[_refreshTokenKey] != null) {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString(_refreshTokenKey, tokenRes.data[_refreshTokenKey]);
      }
    }
    return tokenRes.statusCode == 200;
  }

  /// Queries the playlists for the current user
  Future<void> loadPlaylists() async {
    // Load playlists and liked songs
    final playlistsRes = await _fetchContent(
      method: 'GET',
      url: 'https://api.spotify.com/v1/me/playlists',
    );
    final likedSongsRes = await _fetchContent(
      method: 'GET',
      url: 'https://api.spotify.com/v1/me/tracks',
    );
    if (playlistsRes.statusCode == 200 && likedSongsRes.statusCode == 200) {
      // Map liked Songs
      final likedSongsData = ApiTracksModel.fromJson(likedSongsRes.data);
      final likedSongs = PlaylistModel();
      likedSongs.id = likedSongsID;
      likedSongs.name = translation().likedSongs;
      likedSongs.owner = translation().you;
      likedSongs.total = likedSongsData.total ?? 0;
      likedSongs.tracksHref = 'https://api.spotify.com/v1/me/tracks';
      playlists[likedSongs.id] = likedSongs;

      // Map the playlists via their id
      final playlistsData = ApiPlaylistsModel.fromJson(playlistsRes.data);
      for (var apiPlaylist in (playlistsData.items ?? <ApiPlaylistModel>[])) {
        final playlist = PlaylistModel();
        playlist.id = apiPlaylist.id ?? '';
        playlist.name = apiPlaylist.name ?? '';
        playlist.owner = apiPlaylist.owner?.displayName ?? '';
        playlist.total = apiPlaylist.tracks?.total ?? 0;
        playlist.tracksHref = apiPlaylist.tracks?.href ?? '';
        if (apiPlaylist.images?.isNotEmpty ?? false) playlist.image = apiPlaylist.images?[0].url ?? '';
        playlists[playlist.id] = playlist;
      }
    } else {
      showSnackBar(translation().loadPlaylistError);
    }
  }

  /// Loads more detailed info about the playlist via the given playlist [id]
  /// (the tracks with genres and release date)
  Future<PlaylistInfoModel> loadPlaylistInfo(BuildContext context, String id, Function(double) onProgress) async {
    // Load all tracks and map them to their artists
    final tracks = <String, List<ApiTrackEntryModel>>{};
    final apiTracks = await loadTracks(id);
    for (var track in apiTracks) {
      final artistHref = track.track?.artists?[0].href ?? '';
      if (artistHref != '') {
        if (!tracks.containsKey(artistHref)) {
          tracks[artistHref] = [];
        }
        tracks[artistHref]?.add(track);
      }
    }

    // Prepare the playlist model
    final playlist = PlaylistInfoModel();

    // Iterate through the artist
    var counter = 0;
    var artistResFutures = <Future>[];
    for (var artistRef in tracks.keys) {
      // Load the data
      artistResFutures.add(_loadArtist(artistRef).then((apiArtist) {
        // Update the progress
        counter++;
        onProgress(counter / tracks.length);

        // Parse the response
        if (apiArtist != null) {
          // Get the genres for the artist
          var genres = apiArtist.genres ?? <String>[];
          genres = genres.map((genre) => genre.capitalizeSentence).toList();
          if (genres.isEmpty) genres.add(translation().unknownGenre);
          playlist.artists.add(apiArtist.name ?? '');
          playlist.genres.addAll(genres);

          // Prepare the tracks
          tracks[artistRef]?.forEach((apiTrack) {
            final track = TrackModel();
            track.uri = apiTrack.track?.uri ?? '';
            track.name = apiTrack.track?.name ?? '';
            track.artist = apiArtist.name ?? '';
            try {
              track.releaseDate = DateTime.parse(apiTrack.track?.album?.releaseDate ?? '');
            } catch (_) {}
            track.genres.addAll(genres);
            playlist.tracks.add(track);
          });
        }
      }));
    }

    // Wait for all futures and signalize finish
    await Future.wait(artistResFutures);
    onProgress(1.0);

    return playlist;
  }

  /// Load the tracks for a given playlist [id]
  Future<List<ApiTrackEntryModel>> loadTracks(String id) async {
    final tracks = <ApiTrackEntryModel>[];

    // Get the playlist information
    final playlist = playlists[id];
    final total = playlist?.total ?? 0;

    // Get the tracks in packets of 50
    var offset = 0;
    const steps = 50;
    var tracksResFutures = <Future>[];
    for (; offset < total; offset += steps) {
      tracksResFutures.add(_fetchContent(
        method: 'GET',
        url: '${playlist?.tracksHref}?offset=$offset&limit=$steps',
      ).then((tracksRes) {
        if (tracksRes.statusCode == 200) {
          final apiTracks = ApiTracksModel.fromJson(tracksRes.data);
          final items = apiTracks.items;
          if (items != null) tracks.addAll(items);
        }
      }));
    }

    // Wait for all responses
    await Future.wait(tracksResFutures);
    return tracks;
  }

  /// Loads the data for an artist with a given [artistRef]
  Future<ApiArtistModel?> _loadArtist(String artistRef) async {
    // Check if artist data was cached
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final artistInfo = sharedPreferences.getString(_artistPrefix + artistRef) ?? '';
    if (artistInfo != '') return ApiArtistModel.fromJson(jsonDecode(artistInfo));

    // Request the artist data and cache it
    final artistRes = await _fetchContent(
      method: 'GET',
      url: artistRef,
    );
    if (artistRes.statusCode == 200) {
      sharedPreferences.setString(_artistPrefix + artistRef, jsonEncode(artistRes.data));
      return ApiArtistModel.fromJson(artistRes.data);
    }
    return null;
  }

  /// Adds tracks to a playlist
  Future<bool> addTracks(String id, List<String> tracks) async {
    // Check whether there is something to add
    if (tracks.isEmpty) return true;

    // Add the tracks
    bool success = true;
    const maxPerRequest = 100;
    for (int i = 0; i < tracks.length; i += maxPerRequest) {
      final body = <String, dynamic>{
        'uris': tracks.sublist(i, min(tracks.length, i + maxPerRequest)),
        'position': 0,
      };
      final res = await _fetchContent(
        method: 'POST',
        url: 'https://api.spotify.com/v1/playlists/$id/tracks',
        data: body,
      );
      success = success && res.statusCode == 201;
    }
    return success;
  }

  /// Removes tracks from a playlist
  Future<bool> removeTracks(String id, List<String> tracks) async {
    // Check whether there is something to add
    if (tracks.isEmpty) return true;

    // Remove tracks
    bool success = true;
    var preparedTracks = tracks.map((track) => {'uri': track}).toList();
    const maxPerRequest = 100;
    for (int i = 0; i < tracks.length; i += maxPerRequest) {
      final body = <String, dynamic>{
        'tracks': preparedTracks.sublist(i, min(preparedTracks.length, i + maxPerRequest)),
      };
      final res = await _fetchContent(
        method: 'DELETE',
        url: 'https://api.spotify.com/v1/playlists/$id/tracks',
        data: body,
      );
      success = success && res.statusCode == 200;
    }
    return success;
  }

  /// Fetches content with a given [method] from the API via the given [url]
  Future<Response> _fetchContent({
    required String method,
    required String url,
    dynamic data,
    Map<String, String>? headers,
  }) async {
    // Prepare the headers
    headers ??= <String, String>{};
    headers['Authorization'] ??= 'Bearer $_token';
    headers['Content-Type'] ??= 'application/json';
    headers['Accept'] ??= 'application/json';

    // Execute the request
    try {
      return await Dio().fetch(RequestOptions(path: url, headers: headers, data: data, method: method));
    } catch (e) {
      // Check whether dio threw the error
      if (e is DioError) {
        final response = e.response;
        if (response != null) {
          // Token expired
          if (response.statusCode == 401) {
            await init();
          }
          // Return response or retry if it was 429
          else if (response.statusCode != 429) {
            if (kDebugMode) showSnackBar(response.data);
            return response;
          }
        }
      }
      // Show unknown error
      else {
        showSnackBar(translation().unknownError);
        if (kDebugMode) print(e);
      }

      // Retry in 5 seconds
      return Future.delayed(const Duration(seconds: 5)).then((_) => _fetchContent(
            method: method,
            url: url,
            data: data,
            headers: headers,
          ));
    }
  }
}
