/// ATTENTION: The following models were auto-generated by the plugin "Json to Dart".
/// I simply copied the JSON output from the "playlists" api and the plugin did the rest

class ApiTracksModel {
  ApiTracksModel({
      this.href, 
      this.items, 
      this.limit, 
      this.next, 
      this.offset, 
      this.previous, 
      this.total,});

  ApiTracksModel.fromJson(dynamic json) {
    href = json['href'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(ApiTrackEntryModel.fromJson(v));
      });
    }
    limit = json['limit'];
    next = json['next'];
    offset = json['offset'];
    previous = json['previous'];
    total = json['total'];
  }
  String? href;
  List<ApiTrackEntryModel>? items;
  int? limit;
  String? next;
  int? offset;
  dynamic previous;
  int? total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['href'] = href;
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    map['limit'] = limit;
    map['next'] = next;
    map['offset'] = offset;
    map['previous'] = previous;
    map['total'] = total;
    return map;
  }

}

class ApiTrackEntryModel {
  ApiTrackEntryModel({
      this.addedAt, 
      this.addedBy, 
      this.isLocal, 
      this.primaryColor, 
      this.track, 
      this.videoThumbnail,});

  ApiTrackEntryModel.fromJson(dynamic json) {
    addedAt = json['added_at'];
    addedBy = json['added_by'] != null ? ApiAddedByModel.fromJson(json['added_by']) : null;
    isLocal = json['is_local'];
    primaryColor = json['primary_color'];
    track = json['track'] != null ? ApiTrackModel.fromJson(json['track']) : null;
    videoThumbnail = json['video_thumbnail'] != null ? ApiVideoThumbnailModel.fromJson(json['video_thumbnail']) : null;
  }
  String? addedAt;
  ApiAddedByModel? addedBy;
  bool? isLocal;
  dynamic primaryColor;
  ApiTrackModel? track;
  ApiVideoThumbnailModel? videoThumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['added_at'] = addedAt;
    if (addedBy != null) {
      map['added_by'] = addedBy?.toJson();
    }
    map['is_local'] = isLocal;
    map['primary_color'] = primaryColor;
    if (track != null) {
      map['track'] = track?.toJson();
    }
    if (videoThumbnail != null) {
      map['video_thumbnail'] = videoThumbnail?.toJson();
    }
    return map;
  }

}

class ApiVideoThumbnailModel {
  ApiVideoThumbnailModel({
      this.url,});

  ApiVideoThumbnailModel.fromJson(dynamic json) {
    url = json['url'];
  }
  dynamic url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    return map;
  }

}

class ApiTrackModel {
  ApiTrackModel({
      this.album, 
      this.artists, 
      this.availableMarkets, 
      this.discNumber, 
      this.durationMs, 
      this.episode, 
      this.explicit, 
      this.externalIds, 
      this.externalUrls, 
      this.href, 
      this.id, 
      this.isLocal, 
      this.name, 
      this.popularity, 
      this.previewUrl, 
      this.track, 
      this.trackNumber, 
      this.type, 
      this.uri,});

  ApiTrackModel.fromJson(dynamic json) {
    album = json['album'] != null ? ApiAlbumModel.fromJson(json['album']) : null;
    if (json['artists'] != null) {
      artists = [];
      json['artists'].forEach((v) {
        artists?.add(ApiTracksArtistModel.fromJson(v));
      });
    }
    availableMarkets = json['available_markets'] != null ? json['available_markets'].cast<String>() : [];
    discNumber = json['disc_number'];
    durationMs = json['duration_ms'];
    episode = json['episode'];
    explicit = json['explicit'];
    externalIds = json['external_ids'] != null ? ApiExternalIDModel.fromJson(json['external_ids']) : null;
    externalUrls = json['external_urls'] != null ? ApiExternalUrlModel.fromJson(json['external_urls']) : null;
    href = json['href'];
    id = json['id'];
    isLocal = json['is_local'];
    name = json['name'];
    popularity = json['popularity'];
    previewUrl = json['preview_url'];
    track = json['track'];
    trackNumber = json['track_number'];
    type = json['type'];
    uri = json['uri'];
  }
  ApiAlbumModel? album;
  List<ApiTracksArtistModel>? artists;
  List<String>? availableMarkets;
  int? discNumber;
  int? durationMs;
  bool? episode;
  bool? explicit;
  ApiExternalIDModel? externalIds;
  ApiExternalUrlModel? externalUrls;
  String? href;
  String? id;
  bool? isLocal;
  String? name;
  int? popularity;
  String? previewUrl;
  bool? track;
  int? trackNumber;
  String? type;
  String? uri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (album != null) {
      map['album'] = album?.toJson();
    }
    if (artists != null) {
      map['artists'] = artists?.map((v) => v.toJson()).toList();
    }
    map['available_markets'] = availableMarkets;
    map['disc_number'] = discNumber;
    map['duration_ms'] = durationMs;
    map['episode'] = episode;
    map['explicit'] = explicit;
    if (externalIds != null) {
      map['external_ids'] = externalIds?.toJson();
    }
    if (externalUrls != null) {
      map['external_urls'] = externalUrls?.toJson();
    }
    map['href'] = href;
    map['id'] = id;
    map['is_local'] = isLocal;
    map['name'] = name;
    map['popularity'] = popularity;
    map['preview_url'] = previewUrl;
    map['track'] = track;
    map['track_number'] = trackNumber;
    map['type'] = type;
    map['uri'] = uri;
    return map;
  }

}

class ApiExternalUrlModel {
  ApiExternalUrlModel({
      this.spotify,});

  ApiExternalUrlModel.fromJson(dynamic json) {
    spotify = json['spotify'];
  }
  String? spotify;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['spotify'] = spotify;
    return map;
  }

}

class ApiExternalIDModel {
  ApiExternalIDModel({
      this.isrc,});

  ApiExternalIDModel.fromJson(dynamic json) {
    isrc = json['isrc'];
  }
  String? isrc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isrc'] = isrc;
    return map;
  }

}

class ApiTracksArtistModel {
  ApiTracksArtistModel({
      this.externalUrls, 
      this.href, 
      this.id, 
      this.name, 
      this.type, 
      this.uri,});

  ApiTracksArtistModel.fromJson(dynamic json) {
    externalUrls = json['external_urls'] != null ? ApiExternalUrlModel.fromJson(json['external_urls']) : null;
    href = json['href'];
    id = json['id'];
    name = json['name'];
    type = json['type'];
    uri = json['uri'];
  }
  ApiExternalUrlModel? externalUrls;
  String? href;
  String? id;
  String? name;
  String? type;
  String? uri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (externalUrls != null) {
      map['external_urls'] = externalUrls?.toJson();
    }
    map['href'] = href;
    map['id'] = id;
    map['name'] = name;
    map['type'] = type;
    map['uri'] = uri;
    return map;
  }

}

class ApiAlbumModel {
  ApiAlbumModel({
      this.albumType, 
      this.artists, 
      this.availableMarkets, 
      this.externalUrls, 
      this.href, 
      this.id, 
      this.images, 
      this.name, 
      this.releaseDate, 
      this.releaseDatePrecision, 
      this.totalTracks, 
      this.type, 
      this.uri,});

  ApiAlbumModel.fromJson(dynamic json) {
    albumType = json['album_type'];
    if (json['artists'] != null) {
      artists = [];
      json['artists'].forEach((v) {
        artists?.add(ApiTracksArtistModel.fromJson(v));
      });
    }
    availableMarkets = json['available_markets'] != null ? json['available_markets'].cast<String>() : [];
    externalUrls = json['external_urls'] != null ? ApiExternalUrlModel.fromJson(json['external_urls']) : null;
    href = json['href'];
    id = json['id'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(ApiImageModel.fromJson(v));
      });
    }
    name = json['name'];
    releaseDate = json['release_date'];
    releaseDatePrecision = json['release_date_precision'];
    totalTracks = json['total_tracks'];
    type = json['type'];
    uri = json['uri'];
  }
  String? albumType;
  List<ApiTracksArtistModel>? artists;
  List<String>? availableMarkets;
  ApiExternalUrlModel? externalUrls;
  String? href;
  String? id;
  List<ApiImageModel>? images;
  String? name;
  String? releaseDate;
  String? releaseDatePrecision;
  int? totalTracks;
  String? type;
  String? uri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['album_type'] = albumType;
    if (artists != null) {
      map['artists'] = artists?.map((v) => v.toJson()).toList();
    }
    map['available_markets'] = availableMarkets;
    if (externalUrls != null) {
      map['external_urls'] = externalUrls?.toJson();
    }
    map['href'] = href;
    map['id'] = id;
    if (images != null) {
      map['images'] = images?.map((v) => v.toJson()).toList();
    }
    map['name'] = name;
    map['release_date'] = releaseDate;
    map['release_date_precision'] = releaseDatePrecision;
    map['total_tracks'] = totalTracks;
    map['type'] = type;
    map['uri'] = uri;
    return map;
  }

}

class ApiImageModel {
  ApiImageModel({
      this.height, 
      this.url, 
      this.width,});

  ApiImageModel.fromJson(dynamic json) {
    height = json['height'];
    url = json['url'];
    width = json['width'];
  }
  int? height;
  String? url;
  int? width;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['url'] = url;
    map['width'] = width;
    return map;
  }

}

class ApiAddedByModel {
  ApiAddedByModel({
      this.externalUrls, 
      this.href, 
      this.id, 
      this.type, 
      this.uri,});

  ApiAddedByModel.fromJson(dynamic json) {
    externalUrls = json['external_urls'] != null ? ApiExternalUrlModel.fromJson(json['external_urls']) : null;
    href = json['href'];
    id = json['id'];
    type = json['type'];
    uri = json['uri'];
  }
  ApiExternalUrlModel? externalUrls;
  String? href;
  String? id;
  String? type;
  String? uri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (externalUrls != null) {
      map['external_urls'] = externalUrls?.toJson();
    }
    map['href'] = href;
    map['id'] = id;
    map['type'] = type;
    map['uri'] = uri;
    return map;
  }

}