import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChangeInfoScreen extends StatefulWidget {
  const ChangeInfoScreen({Key? key}) : super(key: key);

  @override
  State<ChangeInfoScreen> createState() => _ChangeInfoScreenState();
}

class _ChangeInfoScreenState extends State<ChangeInfoScreen> {
  late TextEditingController _usernameController;
  late File? _avatar = File("/assets/avatar.png");

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _avatar = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _submitForm() async {
    final String username = _usernameController.text;

    // TODO: Perform the form data submission with username and avatar
    // For example, you can use Dio or another HTTP client to send the data.

    print('Username: $username');
    if (_avatar != null) {
      print('Avatar path: ${_avatar!.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16.0),
            if (_avatar != null)
              Image.file(
                _avatar!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
