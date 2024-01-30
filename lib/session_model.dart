import 'dart:convert';

class SessionList {
  List<Session>? sessions;

  SessionList({
    this.sessions,
  });

  factory SessionList.fromRawJson(String str) =>
      SessionList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SessionList.fromJson(Map<String, dynamic> json) => SessionList(
        sessions: json["sessions"] == null
            ? []
            : List<Session>.from(
                json["sessions"]!.map((x) => Session.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sessions": sessions == null
            ? []
            : List<dynamic>.from(sessions!.map((x) => x.toJson())),
      };
}

class Session {
  String? title;
  String? description;
  int? ftp;
  String? commentPreActivity;
  String? activityType;
  Map<String, dynamic>? structure;

  Session({
    this.title,
    this.description,
    this.ftp,
    this.commentPreActivity,
    this.activityType,
    this.structure,
  });

  factory Session.fromRawJson(String str) => Session.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        title: json["title"],
        description: json["description"],
        ftp: json["ftp"],
        commentPreActivity: json["comment_pre_activity"],
        activityType: json["activity_type"],
        structure: json["structure"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "ftp": ftp,
        "comment_pre_activity": commentPreActivity,
        "activity_type": activityType,
        "structure": structure,
      };
}
