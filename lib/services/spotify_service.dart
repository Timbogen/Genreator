import 'dart:convert';
import 'dart:developer';

import 'package:genreator/models/general/paylist_model.dart';
import 'package:genreator/models/general/track_model.dart';
import 'package:genreator/models/spotify/api_artist_model.dart';
import 'package:genreator/models/spotify/api_playlists_model.dart';
import 'package:genreator/models/spotify/api_tracks_model.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
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

  /// The key for the refresh token
  static const _refreshTokenKey = 'refresh_token';

  /// Client id
  var _clientID = '';

  /// Client secret
  var _clientSecret = '';

  /// The spotify user token
  var _token = '';

  /// The playlists for the current user
  final _playlists = <String, ApiPlaylistModel>{};

  /// Private constructor for singleton
  SpotifyService._privateConstructor() {
    try {
      _clientID = GlobalConfiguration().get('clientID');
      _clientSecret = GlobalConfiguration().get('clientSecret');
    } catch (_) {}
    if (_clientID == '' || _clientSecret == '') log('ATTENTION: Make sure to add a valid "assets/cfg/config.json"!');
  }

  /// The playlists for the current user
  Map<String, ApiPlaylistModel> get playlists {
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
    final tokenRes = await http.post(Uri.parse('https://accounts.spotify.com/api/token'), headers: headers, body: body);
    if (tokenRes.statusCode == 200) {
      final data = jsonDecode(tokenRes.body);

      // Get the token and save the refresh token
      _token = data['access_token'];
      if (data[_refreshTokenKey] != null) {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString(_refreshTokenKey, data[_refreshTokenKey]);
      }
    }
    return tokenRes.statusCode == 200;
  }

  /// Queries the playlists for the current user
  Future<void> loadPlaylists() async {
    final playlistsRes = await _getContent('https://api.spotify.com/v1/me/playlists');
    if (playlistsRes.statusCode == 200) {
      final playlistsData = ApiPlaylistsModel.fromJson(jsonDecode(playlistsRes.body));

      // Map the playlists via their id
      for (var apiPlaylist in (playlistsData.items ?? <ApiPlaylistModel>[])) {
        playlists[apiPlaylist.id ?? ''] = apiPlaylist;
      }
    }
  }

  /// Loads more detailed info about the playlist
  /// (the tracks with genres and release date)
  Future<PlaylistModel> getPlaylistInfo(ApiPlaylistModel apiPlaylist) async {
    final tracks = <String, List<ApiTrackEntryModel>>{};
    var offset = 0;

    // Load all tracks and map them to their artists
    final total = apiPlaylist.tracks?.total ?? 0;
    for (; offset < total; offset += 100) {
      final tracksRes = await _getContent('${apiPlaylist.tracks?.href}?offset=$offset&limit=100');
      if (tracksRes.statusCode == 200) {
        final apiTracks = ApiTracksModel.fromJson(jsonDecode(tracksRes.body));
        apiTracks.items?.forEach((track) {
          final artistHref = track.track?.artists?[0].href ?? '';
          if (artistHref != '') {
            if (!tracks.containsKey(artistHref)) {
              tracks[artistHref] = [];
            }
            tracks[artistHref]?.add(track);
          }
        });
      }
    }

    // Load the artist information
    final playlist = PlaylistModel();
    playlist.id = apiPlaylist.id ?? '';
    playlist.name = apiPlaylist.name ?? '';
    playlist.owner = apiPlaylist.owner?.displayName ?? '';
    if (apiPlaylist.images?.isNotEmpty ?? false) playlist.image = apiPlaylist.images?[0].url ?? '';
    for (var artistRef in tracks.keys) {
      final tracksRes = await _getContent(artistRef);
      if (tracksRes.statusCode == 200) {
        final apiArtist = ApiArtistModel.fromJson(jsonDecode(tracksRes.body));
        final genres = apiArtist.genres ?? <String>[];
        playlist.genres.addAll(genres);

        // Prepare the tracks
        tracks[artistRef]?.forEach((apiTrack) {
          final track = TrackModel();
          track.id = apiTrack.track?.id ?? '';
          try {
            track.releaseDate = DateTime.parse(apiTrack.track?.album?.releaseDate ?? '');
          } catch (_) {}
          track.genres.addAll(genres);
          playlist.tracks.add(track);
        });
      }
    }
    return playlist;
  }

  /// Queries content from the API via the given [url]
  Future<Response> _getContent(String url) {
    var headers = <String, String>{};
    headers['Authorization'] = 'Bearer $_token';
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';
    return http.get(Uri.parse(url), headers: headers);
  }
}
