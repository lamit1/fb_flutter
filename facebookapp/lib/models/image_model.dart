class Image {
  final String? id;
  final String? url;

  const Image({
    required this.id,
    required this.url,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'] as String,
      url: json['url'] as String,
    );
  }

  @override
  String toString() {
    return "$url, $id";
  }
}
