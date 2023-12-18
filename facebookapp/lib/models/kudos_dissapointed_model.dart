class Like {
  String disappointed;
  String kudos;

  Like({
    required this.disappointed,
    required this.kudos,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      disappointed: json['disappointed'] as String,
      kudos: json['kudos'] as String,
    );
  }
}
