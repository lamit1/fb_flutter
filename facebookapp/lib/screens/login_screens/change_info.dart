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
  late String? uid;

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
    print("avata: $_avatar");
  }

  Future<void> _submitForm() async {
    final String username = _usernameController.text;

    showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: SizedBox(
            width: 50.0, // Set the width to your desired size
            height: 50.0, // Set the height to your desired size
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0), // Adjust the radius as needed
            ),
          ),
        )
    );

    var response = await ProfileAPI().changeProfileAfterSignup(username, _avatar!);
    print(response);
    if(response == '1000'){
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Update information successfully"),
            content:
            const Text("You have restored your password"),
            actions: [
              TextButton(
                  onPressed: (){Navigator.pop(context, 'OK');},
                  child: const Text("OK"))
            ],
          )
      );
      Navigator.pushReplacementNamed(context, "/home", arguments: uid);
    }
    else{
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Failed"),
            content:
            const Text("Updated again your information"),
            actions: [
              TextButton(
                  onPressed: (){Navigator.pop(context, 'OK');},
                  child: const Text("OK"))
            ],
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic data = ModalRoute.of(context)?.settings.arguments;
    uid = data[0];
    double imageWidth = 200;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Info',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        backgroundColor: Colors.blue, // Set the background color to blue
        centerTitle: true, // Center the title horizontally
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  if (_avatar != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ClipOval(
                        child: Image.file(
                          _avatar!,
                          width: imageWidth,
                          height: imageWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Enter your username',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.blue),
                            ),
                          ),
                        ),
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
                    child: Center(child: Text('Continue')),

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
