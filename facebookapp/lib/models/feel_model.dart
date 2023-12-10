import 'package:fb_app/models/user_model.dart';

class Feel {
  final String? type;
  final User? poster;

  const Feel({
    this.type,
    this.poster,
  });

  factory Feel.fromJson(Map<String, dynamic> json) {
    return Feel(
      type: json['type'] as String?,
      poster: User.fromJson(json['poster']),
    );
  }

  @override
  String toString() {
    return "$type, $poster";
  }
}