import 'package:fb_app/models/friend_model.dart';
import 'package:fb_app/screens/profile.dart';
import 'package:fb_app/services/api/friend.dart';
import 'package:fb_app/services/api/profile.dart';
import 'package:fb_app/services/storage.dart';
import 'package:flutter/material.dart';

class AllFriendPage extends StatefulWidget {
  const AllFriendPage({super.key});

  @override
  State<AllFriendPage> createState() => _AllFriendPageState();
}

class _AllFriendPageState extends State<AllFriendPage> {
  List<Friend>? userFriendList;
  // List<Friend?> _userFriendFuture;
  String? total;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var userId = await Storage().getUserId();
    if (userId != null) {
      setState(() {
        // _userFriendFuture = FriendAPI().getUserFriends(userId,50);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Danh sách bạn bè')),
        body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(115, 173, 169, 169),
                            borderRadius: BorderRadius.circular(30)),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.black45,
                                size: 32.0,
                              ),
                              SizedBox(
                                width: 350,
                                height: 45,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Tìm kiếm bạn bè',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          textAlign: TextAlign.left,
                          '$total người bạn',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userFriendList?.length,
                        itemBuilder: (BuildContext context, int index) {
                          Friend item = userFriendList![index];

                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                60), // Image border
                                            child: SizedBox.fromSize(
                                              size: const Size.fromRadius(
                                                  56), // Image radius
                                              child: Image.network(
                                                  item.avatar!.isNotEmpty
                                                      ? item.avatar!
                                                      : 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png',
                                                  fit: BoxFit.cover),
                                            ),
                                          )),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 0, 0),
                                            child: Text(
                                              textAlign: TextAlign.left,
                                              item.username!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 0, 0),
                                            child: Text(
                                              textAlign: TextAlign.left,
                                              item.sameFriends!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (builder) {
                                          return SizedBox(
                                            height: 350,
                                            width: double.infinity,
                                            child: Column(
                                              children: [
                                                Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: GestureDetector(
                                                      onTap: () => {},
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.person,
                                                            color:
                                                            Colors.black45,
                                                            size: 24.0,
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                            child: Text(
                                                              'Hiển thị danh sách bạn bè của ${item.username}',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: GestureDetector(
                                                      onTap: () => {},
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.message,
                                                            color:
                                                            Colors.black45,
                                                            size: 24.0,
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                            child: Text(
                                                              'Nhắn tin cho ${item.username}',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: GestureDetector(
                                                      onTap: () => {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PersonalPage(
                                                                      id: item
                                                                          .id!)),
                                                        )
                                                      },
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .picture_in_picture_outlined,
                                                            color:
                                                            Colors.black45,
                                                            size: 24.0,
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                            child: Text(
                                                              'Xem trang cá nhân của ${item.username}',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: GestureDetector(
                                                      onTap: () => {},
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.block_rounded,
                                                            color:
                                                            Colors.black45,
                                                            size: 24.0,
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                            child: Text(
                                                              'Chặn ${item.username}',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: GestureDetector(
                                                      onTap: () => {},
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.person_remove,
                                                            color: Colors.red,
                                                            size: 24.0,
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                            child: Text(
                                                              'Hủy kết bạn với ${item.username}',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 14,
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
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: Colors.black45,
                                    size: 24.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
    );
  }
}
