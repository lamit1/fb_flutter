import 'dart:io';
import 'dart:typed_data';
import 'package:fb_app/core/pallete.dart';
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
  late File? _avatar;

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
    // TODO: Perform the form data submission with username and avatar
    print('Username: $username');
    if (_avatar != null) {
      print('Avatar path: ${_avatar!.path}');
    }
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
                      SizedBox(width: 15,),
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(10), // Adjust padding as needed
                        ),
                        child: Icon(Icons.image, size: 36), // Adjust size as needed
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(child: const Text('Continue'))
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
