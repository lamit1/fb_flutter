class Category {
  final String? id;
  final String? name;
  final String? hasName;

  const Category({
    required this.id,
    required this.name,
    required this.hasName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String?,
      name: json['name'] as String?,
      hasName: json['hasName'] as String?,
    );
  }

  @override
  String toString() {
    return "$id, $name, $hasName";
  }
}
