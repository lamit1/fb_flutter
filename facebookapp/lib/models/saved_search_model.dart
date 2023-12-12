class SavedSearch {
  final String? id;
  final String? keyword;
  final String? created;

  const SavedSearch({
    this.id,
    this.keyword,
    this.created,
  });

  factory SavedSearch.fromJson(Map<String, dynamic> json) {
    return SavedSearch(
      id: json['id'] as String?,
      keyword: json['keyword'] as String?,
      created: json['created'] as String?,
    );
  }

  @override
  String toString() {
    return "$id, $keyword, $created";
  }
}
