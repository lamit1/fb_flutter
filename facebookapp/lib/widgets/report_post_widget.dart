import 'package:flutter/material.dart';
import '../services/api/comment.dart';

class ReportModal extends StatefulWidget {
  final String id;

  const ReportModal({Key? key, required this.id}) : super(key: key);

  @override
  _ReportModalState createState() => _ReportModalState();
}

class _ReportModalState extends State<ReportModal> {
  bool reportSent = false;
  bool sendingReport = false;
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  late String message = ''; // Initialize with an empty string

  @override
  Widget build(BuildContext context) {
    // Check if report is being sent
    if (sendingReport) {
      return const Center(child: CircularProgressIndicator());
    }

    // If report is sent, show the AlertDialog
    if (reportSent) {
      return AlertDialog(
        title: const Text("Report Message"),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      );
    }

    // Default view for reporting
    return AlertDialog(
      title: const Text("Report Post"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: "Subject"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: detailController,
              decoration: const InputDecoration(labelText: "Detail"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              sendingReport = true; // Start sending report
            });

            try {
              message = await CommentAPI().reportPost(widget.id, subjectController.text, detailController.text);
            } catch (e) {
              message = 'Error: ${e.toString()}'; // Handle potential errors
            }

            setState(() {
              sendingReport = false; // Report sending is complete
              reportSent = true; // Report has been sent
            });
          },
          child: const Text("Report"),
        ),
      ],
    );
  }
}
