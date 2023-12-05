class SavedSearch {
  final String? id;
  final String? keyword;
  final String? created;

  const SavedSearch({
    required this.id,
    required this.keyword,
    required this.created,
  });

  factory SavedSearch.fromJson(Map<String, dynamic> json) {
    return SavedSearch(
      id: json['id'] as String,
      keyword: json['keyword'] as String,
      created: json['created'] as String,
    );
  }

  @override
  String toString() {
    return "$id, $keyword, $created";
  }
}
