import 'package:fb_app/screens/preview_avatar.dart';
import 'package:fb_app/screens/preview_coverage_image.dart';
import 'package:fb_app/services/api/profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_info_model.dart';

class EditPersonalPage extends StatefulWidget {
  final UserInfo userInfor;

  const EditPersonalPage({super.key, required this.userInfor});

  @override
  State<EditPersonalPage> createState() => _EditPersonalPageState();
}

class _EditPersonalPageState extends State<EditPersonalPage> {
  late UserInfo userInfor;
  late TextEditingController _descriptionController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    userInfor = widget.userInfor;
    _descriptionController = TextEditingController();
    _cityController = TextEditingController();
    _addressController = TextEditingController();
    _countryController = TextEditingController();

    _descriptionController.value = _descriptionController.value.copyWith(
      text: userInfor.description!,
      selection:
      TextSelection.collapsed(offset: userInfor.description!.length),
    );

    _cityController.value = _descriptionController.value.copyWith(
      text: userInfor.city!,
      selection:
      TextSelection.collapsed(offset: userInfor.description!.length),
    );

    _addressController.value = _descriptionController.value.copyWith(
      text: userInfor.address!,
      selection:
      TextSelection.collapsed(offset: userInfor.description!.length),
    );

    _countryController.value = _descriptionController.value.copyWith(
      text: userInfor.country!,
      selection:
      TextSelection.collapsed(offset: userInfor.description!.length),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void navigateToPreviewAvatar(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewAvatar(
          imagePath: imagePath,
          userInfor: userInfor,
        ),
      ),
    );
  }

  void navigateToPreviewCoverageImage(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewCoverageImage(
          imagePath: imagePath,
          userInfor: userInfor,
        ),
      ),
    );
  }

  Future getAvatarImage() async {
    try {
      // Chọn ảnh từ gallery
      var pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 800,
        maxWidth: 800,
      );

      if (pickedFile == null) {
        // Người dùng không chọn ảnh
        return;
      }

      navigateToPreviewAvatar(pickedFile.path);
    } catch (e) {
      rethrow;
    }
  }

  Future getCoverImage() async {
    try {
      // Chọn ảnh từ gallery
      var pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 800,
        maxWidth: 800,
      );

      if (pickedFile == null) {
        // Người dùng không chọn ảnh
        return;
      }

      navigateToPreviewCoverageImage(pickedFile.path);
    } catch (e) {
      rethrow;
    }
  }

  Future saveUserInfor() async {
    try {
      await ProfileAPI().setUserInfo(
          widget.userInfor.username!,
          widget.userInfor.description!,
          null!,
          widget.userInfor.address!,
          widget.userInfor.city!,
          widget.userInfor.country!,
          null!,
          widget.userInfor.link!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chỉnh sửa trang cá nhân'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ảnh đại diện',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              getAvatarImage();
                            },
                            child: const Text(
                              'Chỉnh sửa',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.blue),
                            ),
                          )),
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.all(5.0),
                height: 300,
                child: GestureDetector(
                  onTap: () => {getAvatarImage()},
                  child: CircleAvatar(
                    radius: 120,
                    backgroundImage: NetworkImage(userInfor
                        .avatar!.isNotEmpty
                        ? userInfor.avatar!
                        : 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png'),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ảnh bìa',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: () {
                            getCoverImage();
                          },
                          child: const Text(
                            'Chỉnh sửa',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: GestureDetector(
                  onTap: () => {getCoverImage()},
                  child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(56), // Image radius
                          child: Image.network(
                              userInfor.coverAvatar!.isNotEmpty
                                  ? userInfor.coverAvatar!
                                  : 'https://wallpapers.com/images/hd/light-grey-background-cxk0x5hxxykvb55z.jpg',
                              fit: BoxFit.cover),
                        ),
                      )),
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tiểu sử',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              userInfor.description =
                                  _descriptionController.text;
                            });
                            saveUserInfor();
                          },
                          child: const Text(
                            'Lưu',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tiểu sử',
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chi tiết',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              userInfor.address = _addressController.text;
                              userInfor.city = _cityController.text;
                              userInfor.country = _countryController.text;
                            });
                            saveUserInfor();
                          },
                          child: const Text(
                            'Chỉnh sửa',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.work,
                          color: Colors.black45,
                          size: 24.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _cityController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Làm việc tại',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.home,
                          color: Colors.black45,
                          size: 24.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Sống tại',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.location_pin,
                          color: Colors.black45,
                          size: 24.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _countryController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Đến từ',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
