class ImageNetwork {
  final String? id;
  final String? url;

  const ImageNetwork({
    this.id,
    this.url,
  });

  factory ImageNetwork.fromJson(Map<String, dynamic> json) {
    return ImageNetwork(
      id: json['id'] as String?,
      url: json['url'] as String?,
    );
  }

  @override
  String toString() {
    return "$url, $id";
  }
}
