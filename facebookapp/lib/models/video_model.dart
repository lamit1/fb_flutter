class Video {
  final String? url;
  final String? thumb;

  const Video({
    required this.url,
    required this.thumb,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      url: json['url'] as String,
      thumb: json['thumb'] as String,
    );
  }

  @override
  String toString() {
    return "$url, $thumb";
  }
}
