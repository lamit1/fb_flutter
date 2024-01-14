import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/user_info_model.dart';
import 'package:fb_app/services/api/block.dart';
import 'package:fb_app/services/api/settings.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddCoins extends StatelessWidget {
  final UserInfo userInfo;
  final VoidCallback? reloadData;
  final BuildContext context;

  const AddCoins({super.key, required this.userInfo, required this.context, this.reloadData});

  void popBackScreen() {
    Navigator.pop(context);
  }

  void showTimedAlertDialog(String title, String content, Duration duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(duration, () {
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void buyCoins(coins) async {
    try {
      String? resp = await SettingAPI().buyCoins(
        'buy',
        coins,
      );
      if (resp != null) {
        Logger().d('Buy');
        reloadData!();
        showTimedAlertDialog('Success', 'Buy coins successfully.', const Duration(seconds: 2));
      }
    } catch (error) {
      Logger().d('Error Buy: $error');
      showTimedAlertDialog('Error', 'Failed to buy coins.', const Duration(seconds: 2));
    }
  }

  Widget _buildCoinCard(int amount, int coins) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${amount}k VND = $coins Coins',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                buyCoins(coins.toString());
              },
              child: const Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
        title: const Text('Buy Coins'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 3,
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(
                        userInfo.avatar != null
                            ? userInfo.avatar!
                            : 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png'
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userInfo.username != null ? userInfo.username! : '',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 24),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 15.0,
                                  backgroundImage: NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7rjB8BcKmkkifnTHKogjZ3WxZItOmGgRItiyH8g9ph4xbppnClyAJg5D7WyO6Rys-OBo&usqp=CAU'
                                  ),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  '${userInfo.coins ?? '0'} coins',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return _buildCoinCard(20, 190);
                case 1:
                  return _buildCoinCard(50, 475);
                case 2:
                  return _buildCoinCard(100, 1000);
                case 3:
                  return _buildCoinCard(200, 2025);
                case 4:
                  return _buildCoinCard(500, 5150);
                case 5:
                  return _buildCoinCard(1000, 11325);
                default:
                  return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
