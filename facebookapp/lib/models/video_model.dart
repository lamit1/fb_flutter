class Video {
  final String? url;
  final String? thumb;

  const Video({
    this.url,
    this.thumb,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      url: json['url'] ?? "",
      thumb: json['thumb'] ?? "",
    );
  }

  @override
  String toString() {
    return "$url, $thumb";
  }
}
