import 'package:fb_app/models/feel_model.dart';

class FeelList {
  final String id;
  final Feel feel;

  const FeelList({
    required this.id,
    required this.feel,
  });

  factory FeelList.fromJson(Map<String, dynamic> json) {
    return FeelList(
      id: json['id'] as String,
      feel: Feel.fromJson(json['feel']),
    );
  }

  @override
  String toString() {
    return "$id, $feel";
  }
}