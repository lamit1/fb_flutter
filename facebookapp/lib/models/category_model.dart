class Category {
  final String? id;
  final String? name;
  final String? hasName;

  const Category({
    this.id,
    this.name,
    this.hasName,
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
