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

  Map<String, dynamic> toJson() {
    return {
      'like_comment': likeComment,
      'from_friends': fromFriends,
      'requested_friend': requestedFriend,
      'suggested_friend': suggestedFriend,
      'birthday': birthday,
      'video': video,
      'report': report,
      'sound_on': soundOn,
      'notification_on': notificationOn,
      'vibrant_on': vibrantOn,
      'led_on': ledOn,
    };
  }

  PushSetting copyWith(
    String? key,
    String? value,
  ) {
    return PushSetting(
      likeComment: key == 'like_comment' ? value : likeComment,
      fromFriends: key == 'from_friends' ? value : fromFriends,
      requestedFriend: key == 'requested_friend' ? value : requestedFriend,
      suggestedFriend: key == 'suggested_friend' ? value : suggestedFriend,
      birthday: key == 'birthday' ? value : birthday,
      video: key == 'video' ? value : video,
      report: key == 'report' ? value : report,
      soundOn: key == 'sound_on' ? value : soundOn,
      notificationOn: key == 'notification_on' ? value : notificationOn,
      vibrantOn: key == 'vibrant_on' ? value : vibrantOn,
      ledOn: key == 'led_on' ? value : ledOn,
    );
  }

  bool equals(PushSetting data) {
    if(data.likeComment != likeComment) return false;
    if(data.fromFriends != fromFriends) return false;
    if(data.requestedFriend != requestedFriend) return false;
    if(data.suggestedFriend != suggestedFriend) return false;
    if(data.birthday != birthday) return false;
    if(data.video != video) return false;
    if(data.report != report) return false;
    if(data.soundOn != soundOn) return false;
    if(data.notificationOn != notificationOn) return false;
    if(data.vibrantOn != vibrantOn) return false;
    if(data.ledOn != ledOn) return false;
    return true;
  }
}
