import 'package:fb_app/models/edit_user_profile_model.dart';
import 'package:fb_app/screens/preview_avatar.dart';
import 'package:fb_app/screens/preview_coverage_image.dart';
import 'package:fb_app/services/api/profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_info_model.dart';

class EditPersonalPage extends StatefulWidget {
  final UserInfo userInfo;
  Function? setResponse;
  EditPersonalPage({super.key, required this.userInfo, this.setResponse});

  @override
  State<EditPersonalPage> createState() => _EditPersonalPageState();
}

class _EditPersonalPageState extends State<EditPersonalPage> {
  late UserInfo userInfo;
  late final TextEditingController _descriptionController = TextEditingController();
  late final TextEditingController _cityController = TextEditingController();
  late final TextEditingController _addressController = TextEditingController();
  late final TextEditingController _countryController = TextEditingController();
  late final TextEditingController _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userInfo = widget.userInfo;
    _cityController.text =  userInfo.city!;
    _addressController.text =  userInfo.address!;
    _countryController.text =  userInfo.country!;
    _linkController.text =  userInfo.link!;

    _descriptionController.value = _descriptionController.value.copyWith(
      text: userInfo.description,
      selection:
      TextSelection.collapsed(offset: userInfo.description!.length),
    );

    _cityController.value = _descriptionController.value.copyWith(
      text: userInfo.city,
      selection:
      TextSelection.collapsed(offset: userInfo.description!.length),
    );

    _addressController.value = _descriptionController.value.copyWith(
      text: userInfo.address,
      selection:
      TextSelection.collapsed(offset: userInfo.description!.length),
    );

    _countryController.value = _descriptionController.value.copyWith(
      text: userInfo.country,
      selection:
      TextSelection.collapsed(offset: userInfo.description!.length),
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
          userInfo: userInfo,
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
          userInfo: userInfo,
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
      } else {
        navigateToPreviewAvatar(pickedFile.path);
      }
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

  void saveUserInfo() async {
    print(123);
    try {
      EditProfileResponse response = await ProfileAPI().setUserInfo(
          widget.userInfo.username ?? "",
          _descriptionController.text,
          null,
          _addressController.text,
          _cityController.text,
          _countryController.text,
          null,
          _linkController.text);
      if(response!=null) {
        widget.setResponse!(
          response.avatar,
          response.coverImage,
          _descriptionController.text,
          response.country,
          response.city,
          _addressController.text,
          response.link,
          );
        //TODO: Show success modal box
      } else {
        //TODO: Show failed modal box
        return;
      }
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
                    backgroundImage: NetworkImage(userInfo
                        .avatar!.isNotEmpty
                        ? userInfo.avatar!
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
                              userInfo.coverAvatar != null
                                  ? userInfo.coverAvatar!
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
                            saveUserInfo();
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
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
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
                              controller: _addressController,
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
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.location_city,
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
                                labelText: 'Đang ở tại thành phố',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
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
                                labelText: 'Sống tại quốc gia',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.link,
                          color: Colors.black45,
                          size: 24.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _linkController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Link',
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
