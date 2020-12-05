class JustListen {
  String id;
  String link;
  String audio;
  String image;
  String title;
  Podcast podcast;
  String thumbnail;
  String description;
  int pubDateMs;
  String listennotesUrl;
  int audioLengthSec;
  bool explicitContent;
  bool maybeAudioInvalid;
  String listennotesEditUrl;

  JustListen(
      {this.id,
      this.link,
      this.audio,
      this.image,
      this.title,
      this.podcast,
      this.thumbnail,
      this.description,
      this.pubDateMs,
      this.listennotesUrl,
      this.audioLengthSec,
      this.explicitContent,
      this.maybeAudioInvalid,
      this.listennotesEditUrl});

  JustListen.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    audio = json['audio'];
    image = json['image'];
    title = json['title'];
    podcast =
        json['podcast'] != null ? new Podcast.fromJson(json['podcast']) : null;
    thumbnail = json['thumbnail'];
    description = json['description'];
    pubDateMs = json['pub_date_ms'];
    listennotesUrl = json['listennotes_url'];
    audioLengthSec = json['audio_length_sec'];
    explicitContent = json['explicit_content'];
    maybeAudioInvalid = json['maybe_audio_invalid'];
    listennotesEditUrl = json['listennotes_edit_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['link'] = this.link;
    data['audio'] = this.audio;
    data['image'] = this.image;
    data['title'] = this.title;
    if (this.podcast != null) {
      data['podcast'] = this.podcast.toJson();
    }
    data['thumbnail'] = this.thumbnail;
    data['description'] = this.description;
    data['pub_date_ms'] = this.pubDateMs;
    data['listennotes_url'] = this.listennotesUrl;
    data['audio_length_sec'] = this.audioLengthSec;
    data['explicit_content'] = this.explicitContent;
    data['maybe_audio_invalid'] = this.maybeAudioInvalid;
    data['listennotes_edit_url'] = this.listennotesEditUrl;
    return data;
  }
}

class Podcast {
  String id;
  String image;
  String title;
  String publisher;
  String thumbnail;
  String listenScore;
  String listennotesUrl;
  String listenScoreGlobalRank;

  Podcast(
      {this.id,
      this.image,
      this.title,
      this.publisher,
      this.thumbnail,
      this.listenScore,
      this.listennotesUrl,
      this.listenScoreGlobalRank});

  Podcast.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
    publisher = json['publisher'];
    thumbnail = json['thumbnail'];
    listenScore = json['listen_score'];
    listennotesUrl = json['listennotes_url'];
    listenScoreGlobalRank = json['listen_score_global_rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['title'] = this.title;
    data['publisher'] = this.publisher;
    data['thumbnail'] = this.thumbnail;
    data['listen_score'] = this.listenScore;
    data['listennotes_url'] = this.listennotesUrl;
    data['listen_score_global_rank'] = this.listenScoreGlobalRank;
    return data;
  }
}