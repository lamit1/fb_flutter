import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/friend_model.dart';
import 'package:fb_app/models/info.dart';
import 'package:fb_app/models/post_model.dart';
import 'package:fb_app/models/user_info_model.dart';
import 'package:fb_app/screens/all_friend_page.dart';
import 'package:fb_app/screens/edit_personal_page.dart';
import 'package:fb_app/screens/preview_avatar.dart';
import 'package:fb_app/screens/preview_coverage_image.dart';
import 'package:fb_app/screens/setting_personal_page.dart';
import 'package:fb_app/services/api/post.dart';
import 'package:fb_app/services/api/profile.dart';
import 'package:fb_app/services/api/friend.dart';
import 'package:fb_app/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ProfileScreen extends StatefulWidget {
  final String id;

  const ProfileScreen({super.key, required this.id});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserInfo userInfo = UserInfo();
  late List<Friend>? userFriends;

  // late List<Post>? listPost;

  @override
  void initState() {
    super.initState;
    getData();
  }

  void getData() async {
    UserInfo user = await ProfileAPI().getUserInfo(widget.id);
    List<Friend>? friends = await FriendAPI().getUserFriends(
        '0', '6', widget.id);
    // List<Post>? posts = await PostAPI().getListPosts(
    //     widget.id,
    //     '1',
    //     '1',
    //     "1.0",
    //     "1.0",
    //     '0',
    //     "0",
    //     "10");

    setState(() {
      userInfo = user;
      userFriends = friends;
      // listPost = posts;
    });
  }

  void navigateToPreviewAvatar(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PreviewAvatar(
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
        builder: (context) =>
            PreviewCoverageImage(
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

  void setResponse(String avatarUrl,
      String coverImageUrl,
      String description,
      String city,
      String country,
      String address,
      String link) {
    setState(() {
      userInfo.avatar = avatarUrl;
      userInfo.coverAvatar = coverImageUrl;
      userInfo.description = description;
      userInfo.country = country;
      userInfo.city = city;
      userInfo.address = address;
      userInfo.link = link;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Trang cá nhân'),
        ),
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 300,
                      ),
                      Container(
                          padding: const EdgeInsets.all(5.0),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 210,
                          child: GestureDetector(
                            onTap: () =>
                            {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (builder) {
                                    return SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () =>
                                                    getCoverImage(),
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .picture_in_picture_outlined,
                                                      color: Colors.black45,
                                                      size: 24.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.all(
                                                          20),
                                                      child: Text(
                                                        'Xem ảnh bìa',
                                                        textAlign: TextAlign
                                                            .center,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () =>
                                                    getCoverImage(),
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.upload,
                                                      color: Colors.black45,
                                                      size: 24.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.all(
                                                          20),
                                                      child: Text(
                                                        'Tải ảnh lên',
                                                        textAlign: TextAlign
                                                            .center,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    );
                                  })
                            },
                            child: Container(
                                child: ClipRRect(
                                  borderRadius:
                                  const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  // Image border
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        56), // Image radius
                                    child: Image.network(
                                        userInfo.coverAvatar != null
                                            ? userInfo.coverAvatar!
                                            : 'https://wallpapers.com/images/hd/light-grey-background-cxk0x5hxxykvb55z.jpg',
                                        fit: BoxFit.cover),
                                  ),
                                )),
                          )),
                      Positioned(
                          top: 130,
                          left: 130,
                          child: Center(
                            child: GestureDetector(
                                onTap: () =>
                                {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (builder) {
                                        return SizedBox(
                                          height: 100,
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .all(8.0),
                                                  child:
                                                  GestureDetector(
                                                    onTap: () =>
                                                        getAvatarImage(),
                                                    child: const Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .photo_outlined,
                                                          color: Colors
                                                              .black45,
                                                          size: 24.0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsets
                                                              .all(
                                                              20),
                                                          child: Text(
                                                            'Chọn ảnh đại diện',
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style:
                                                            TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize:
                                                              20,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        );
                                      })
                                },
                                child: CircleAvatar(
                                  radius: 74.0,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 70.0,
                                    backgroundImage: NetworkImage(
                                        userInfo.avatar != null
                                            ? userInfo.avatar!
                                            : 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png'),
                                  ),

                                )),
                          )),
                    ],
                  ),
                  Text(
                    userInfo.username != null
                        ? userInfo.username!
                        : "unknow",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      userInfo.description != null
                          ? userInfo.description!
                          : "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey[250],
                          textStyle: const TextStyle(color: Colors.black),),
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Edit profile')
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 3,
                        child: Container(
                          color: const Color.fromARGB(
                              139, 140, 141, 142), // Màu nền của SizedBox
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.home,
                              color: Colors.black45,
                              size: 24.0,
                              semanticLabel:
                              'Text to announce in accessibility modes',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Chỗ ở ',
                                  style: const TextStyle(fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: userInfo
                                            .address != null
                                            ? userInfo.address!
                                            : 'unknow',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_city,
                              color: Colors.black45,
                              size: 24.0,
                              semanticLabel:
                              'Text to announce in accessibility modes',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Sống tại thành phố ',
                                  style: const TextStyle(fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: userInfo.city != null
                                            ? userInfo.city!
                                            : 'unknown',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color: Colors.black45,
                              size: 24.0,
                              semanticLabel:
                              'Text to announce in accessibility modes',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Đến từ ',
                                  style: const TextStyle(fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: userInfo
                                            .country != null
                                            ? userInfo.country!
                                            : "unknow",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.link,
                              color: Colors.black45,
                              size: 24.0,
                              semanticLabel:
                              'Text to announce in accessibility modes',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text.rich(
                                TextSpan(
                                  style: const TextStyle(fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: userInfo
                                            .link != null
                                            ? userInfo.link!
                                            : "unknow",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            color: Palette.facebookBlue
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    child: TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 187, 226, 245)),
                          overlayColor:
                          MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return Colors.blue.withOpacity(0.12);
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditPersonalPage(
                                      userInfo: userInfo,
                                    )),
                          );
                        },
                        child: const Text(
                          'Chỉnh sửa chi tiết công khai',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 3,
                        child: Container(
                          color: const Color.fromARGB(
                              139, 140, 141, 142), // Màu nền của SizedBox
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Bạn bè',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () => {},
                                  child: const Text(
                                    'Tìm bạn bè',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        color: Colors.blue),
                                  ),
                                )),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.all(8.0),
                        //       child: Text(
                        //         textAlign: TextAlign.left,
                        //         "${userFriends.data.total.toString()} người bạn",
                        //         style: const TextStyle(
                        //           fontWeight: FontWeight.w400,
                        //           fontSize: 18,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: userFriends != null
                        ? userFriends!.length > 3
                        ? 250
                        : 150
                        : 0,
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0, // Khoảng cách giữa các cột
                        mainAxisSpacing: 8.0, // Khoảng cách giữa các hàng
                      ),
                      itemCount: userFriends!.length,
                      itemBuilder: (context, index) {
                        var item = userFriends![index];
                        return SizedBox(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(50),
                                  child: Image.network(
                                    item.avatar != null
                                        ? item.avatar!
                                        : 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                    item.username!,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    child: TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 208, 211, 213)),
                          overlayColor:
                          MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return Colors.blue.withOpacity(0.12);
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //       const AllFriendPage()),
                          // );
                        },
                        child: const Text(
                          'Xem tất cả bạn bè',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 15,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 144, 142, 142)),
                    ),
                  ),
                  Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Bài viết',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(userInfo
                                          .avatar != null
                                          ? userInfo.avatar!
                                          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png'),
                                    )),
                                // SizedBox(
                                //     width: 300,
                                //     height: 60,
                                //     child: MaterialButton(
                                //         onPressed: () => {
                                //           Navigator.push(
                                //               context,
                                //               MaterialPageRoute(
                                //                   builder: (context) =>
                                //                   const PostArticle()))
                                //         },
                                //         child: const Row(
                                //           children: [
                                //             Expanded(
                                //               child: Text(
                                //                 'Bạn đang nghĩ gì?',
                                //                 textAlign: TextAlign.left,
                                //               ),
                                //             ),
                                //           ],
                                //         ))),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 2,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color:
                                  Color.fromARGB(255, 183, 180, 180)),
                            ),
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 30,
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 15,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color:
                                  Color.fromARGB(255, 144, 142, 142)),
                            ),
                          ),
                        ]),
                  )
                ]
            )
        )
    );
  }
}