class ApiArtistModel {
  ApiArtistModel({
      this.externalUrls, 
      this.followers, 
      this.genres, 
      this.href, 
      this.id, 
      this.images, 
      this.name, 
      this.popularity, 
      this.type, 
      this.uri,});

  ApiArtistModel.fromJson(dynamic json) {
    externalUrls = json['external_urls'] != null ? ApiExternalUrl.fromJson(json['external_urls']) : null;
    followers = json['followers'] != null ? ApiFollower.fromJson(json['followers']) : null;
    genres = json['genres'] != null ? json['genres'].cast<String>() : [];
    href = json['href'];
    id = json['id'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(ApiImage.fromJson(v));
      });
    }
    name = json['name'];
    popularity = json['popularity'];
    type = json['type'];
    uri = json['uri'];
  }
  ApiExternalUrl? externalUrls;
  ApiFollower? followers;
  List<String>? genres;
  String? href;
  String? id;
  List<ApiImage>? images;
  String? name;
  int? popularity;
  String? type;
  String? uri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (externalUrls != null) {
      map['external_urls'] = externalUrls?.toJson();
    }
    if (followers != null) {
      map['followers'] = followers?.toJson();
    }
    map['genres'] = genres;
    map['href'] = href;
    map['id'] = id;
    if (images != null) {
      map['images'] = images?.map((v) => v.toJson()).toList();
    }
    map['name'] = name;
    map['popularity'] = popularity;
    map['type'] = type;
    map['uri'] = uri;
    return map;
  }

}

class ApiImage {
  ApiImage({
      this.height, 
      this.url, 
      this.width,});

  ApiImage.fromJson(dynamic json) {
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

class ApiFollower {
  ApiFollower({
      this.href, 
      this.total,});

  ApiFollower.fromJson(dynamic json) {
    href = json['href'];
    total = json['total'];
  }
  dynamic href;
  int? total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['href'] = href;
    map['total'] = total;
    return map;
  }

}

class ApiExternalUrl {
  ApiExternalUrl({
      this.spotify,});

  ApiExternalUrl.fromJson(dynamic json) {
    spotify = json['spotify'];
  }
  String? spotify;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['spotify'] = spotify;
    return map;
  }

}