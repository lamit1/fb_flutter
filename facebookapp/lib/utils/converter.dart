import 'package:intl/intl.dart';

String convertTimestamp(String timestamp) {
  DateTime now = DateTime.now();
  DateTime postTime = DateTime.parse(timestamp);

  // Calculate the difference in time
  Duration difference = now.difference(postTime);

  if (difference.inMinutes < 1) {
    return "Just posted ...";
  } else if (difference.inHours < 1) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inDays < 1 && difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago"; // Adjusted condition
  } else if (difference.inDays < 1) {
    return "${difference.inHours} hours ago";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  } else {
    // If none of the above conditions are met, format as "dd/mm/yyyy"
    return DateFormat('dd/MM/yyyy').format(postTime);
  }
}