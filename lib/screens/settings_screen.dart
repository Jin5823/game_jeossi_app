import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/tools/token_manage.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  List<String> _settingsList = ['약관확인', '로그아웃'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            brightness: Brightness.light,
            backgroundColor: Palette.customBackground,
            title: Text(
              '설정',
              style: const TextStyle(
                color: Palette.mainPurple,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2,
              ),
            ),
            centerTitle: false,
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                title: Text(_settingsList[index]),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  if (index == _settingsList.length-1){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('로그아웃 하시겠습니까?'),
                        content: Text('보안을 위해 종료 됩니다.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('아니요'),
                          ),
                          TextButton(
                            onPressed: () {
                              TokenHelper.getInstance.clear();
                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                              // exit(0);
                            },
                            child: Text('네'),
                          ),
                        ],
                      ),
                    );
                  }},
              );},
              childCount: _settingsList.length,
            ),
          ),
        ],
      ),
    );
  }
}
