class PushSetting {
  final String? likeComment;
  final String? fromFriends;
  final String? requestedFriend;
  final String? suggestedFriend;
  final String? birthday;
  final String? video;
  final String? report;
  final String? soundOn;
  final String? notificationOn;
  final String? vibrantOn;
  final String? ledOn;

  const PushSetting({
    this.likeComment,
    this.fromFriends,
    this.requestedFriend,
    this.suggestedFriend,
    this.birthday,
    this.video,
    this.report,
    this.soundOn,
    this.notificationOn,
    this.vibrantOn,
    this.ledOn,
  });

  factory PushSetting.fromJson(Map<String, dynamic> json) {
    return PushSetting(
      likeComment: json['like_comment'] as String?,
      fromFriends: json['from_friends'] as String?,
      requestedFriend: json['requested_friend'] as String?,
      suggestedFriend: json['suggested_friend'] as String?,
      birthday: json['birthday'] as String?,
      video: json['video'] as String?,
      report: json['report'] as String?,
      soundOn: json['sound_on'] as String?,
      notificationOn: json['notification_on'] as String?,
      vibrantOn: json['vibrant_on'] as String?,
      ledOn: json['led_on'] as String?,
    );
  }

  @override
  String toString() {
    return "$likeComment, $fromFriends, $requestedFriend, $suggestedFriend, $birthday, $video, $report, $soundOn, $notificationOn, $vibrantOn, $ledOn";
  }
}
