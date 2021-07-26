import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/utils/sp_utils.dart';
import 'package:game_jeossi_app/screens/screens.dart';
import 'package:game_jeossi_app/tools/token_manage.dart';
import 'package:game_jeossi_app/utils/navigator_utils.dart';


class IndexScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexScreenState();
  }
}


class _IndexScreenState extends State<IndexScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  void initLogin() async {
    // 초기화
    await SPUtil.init();
    TokenHelper.getInstance.init();
    // 로그인 하여 토큰이 보관 확인 그리고 토큰이 유효한지 확인
    if (TokenHelper.getInstance.userToken == null){
      NavigatorUtils.pushPageByFade(
          context: context, targPage: WelcomeScreen(), isReplace: true);
    }else{
      NavigatorUtils.pushPageByFade(
          context: context, targPage: NavScreen(), isReplace: true);
    }
  }
}
