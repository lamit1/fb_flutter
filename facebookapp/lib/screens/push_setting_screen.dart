import 'package:flutter/material.dart';
import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/push_setting_model.dart';
import 'package:fb_app/services/api/settings.dart';
import 'package:logger/logger.dart';

class PushSettingPage extends StatefulWidget {
  const PushSettingPage({Key? key}) : super(key: key);

  @override
  State<PushSettingPage> createState() => _PushSettingPageState();
}

class _PushSettingPageState extends State<PushSettingPage> {
  late PushSetting data = PushSetting();
  late PushSetting originalData;
  bool isDataChanged = false;

  @override
  void initState() {
    super.initState();
    loadPushSettings();
  }

  void loadPushSettings() async {
    try {
      PushSetting? fetchedPushSettings = await SettingAPI().getPushSettings();
      if (fetchedPushSettings != null) {
        setState(() {
          data = fetchedPushSettings;
          originalData = fetchedPushSettings;
        });
      }
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  void reloadPushSettingList() {
    loadPushSettings();
  }

  void showTimedAlertDialog(String title, String content, Duration duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(duration, () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }

  void setData() async {
    try {
      String? resp = await SettingAPI().setPushSettings(
        data.likeComment ?? '1',
        data.fromFriends ?? '1',
        data.requestedFriend ?? '1',
        data.suggestedFriend ?? '1',
        data.birthday ?? '1',
        data.video ?? '1',
        data.report ?? '1',
        data.soundOn ?? '1',
        data.notificationOn ?? '1',
        data.vibrantOn ?? '1',
        data.ledOn ?? '1',
      );
      if (resp != null) {
        print('Done');
        reloadPushSettingList();
        showTimedAlertDialog('Success', 'Setting successfully.', const Duration(seconds: 2));
        setState(() {
          originalData = data;
          isDataChanged = false;
        });
      }
    } catch (error) {
      print('Error Setting: $error');
      showTimedAlertDialog('Error', 'Failed to Setting.', const Duration(seconds: 2));
    }
  }

  String formatSettingKey(String input) {
    List<String> words = input.split('_');
    List<String> capitalizedWords = words.map((word) {
      return word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '';
    }).toList();
    return capitalizedWords.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: isDataChanged ? () => setData() : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.toJson().keys.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final settingKey = data.toJson().keys.elementAt(index);
            final settingValue = data.toJson()[settingKey];
            return Card(
              child: ListTile(
                title: Text(formatSettingKey(settingKey)),
                trailing: Switch(
                  value: settingValue == '1',
                  onChanged: (newValue) {
                    setState(() {
                      data = data.copyWith(
                        settingKey,
                        newValue ? '1' : '0'
                      );
                      isDataChanged = !originalData.equals(data);
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
