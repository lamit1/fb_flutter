class PostNoti {
  final String? id;
  final String? described;
  final String? status;

  const PostNoti({
    this.id,
    this.described,
    this.status,
  });

  factory PostNoti.fromJson(Map<String?, dynamic> json) {
    return PostNoti(
      id: json['id'] as String?,
      described: json['described'] as String?,
      status: json['status'] as String?,
    );
  }

  @override
  String toString() {
    return "$id, $described, $status";
  }
}
