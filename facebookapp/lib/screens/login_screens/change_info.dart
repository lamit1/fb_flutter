import 'dart:io';
import 'package:fb_app/services/api/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ChangeInfoScreen extends StatefulWidget {
  const ChangeInfoScreen({Key? key}) : super(key: key);

  @override
  State<ChangeInfoScreen> createState() => _ChangeInfoScreenState();
}

class _ChangeInfoScreenState extends State<ChangeInfoScreen> {
  late TextEditingController _usernameController;
  File? _avatar;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _initAvatar();
  }

  Future<void> _initAvatar() async {
    final ByteData data = await rootBundle.load('assets/avatar.png');
    final File file = File('${(await getTemporaryDirectory()).path}/avatar.png');
    await file.writeAsBytes(data.buffer.asUint8List());
    setState(() {
      _avatar = file;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final ByteData data = await rootBundle.load('assets/avatar.png');
    final File file = File('${(await getTemporaryDirectory()).path}/avatar.png');
    await file.writeAsBytes(data.buffer.asUint8List());
    setState(() {
      _avatar = pickedFile != null ? File(pickedFile.path) : file;
    });
  }

  Future<void> _submitForm() async {
    final String username = _usernameController.text;
    File submitAvatar = _avatar as File;
    await ProfileAPI().changeProfileAfterSignup(username, submitAvatar);
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = 400;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  if (_avatar != null)
                    Image.file(
                      _avatar!,
                      width: imageWidth,
                      height: imageWidth,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Enter your username',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.blue),
                              ),
                            ),
                          )
                      ),
                      const SizedBox(width: 15,),
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10), // Adjust padding as needed
                        ),
                        child: const Icon(Icons.image, size: 36), // Adjust size as needed
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(child: Text('Continue'))
                ),
              ),
            ],
          ),
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
