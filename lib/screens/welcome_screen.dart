import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/screens/screens.dart';
import 'package:game_jeossi_app/utils/navigator_utils.dart';
import 'package:game_jeossi_app/widgets/welcome_widgets.dart';


class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: WelcomeBackground(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "환영합니다",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.05),
                    SvgPicture.asset(
                      "assets/icons/chat.svg",
                      height: size.height * 0.45,
                    ),
                    SizedBox(height: size.height * 0.05),
                    RoundedButton(
                      text: "로그인",
                      press: () {
                        NavigatorUtils.pushPageByFade(
                            context: context, targPage: LoginScreen(), isReplace: true);
                        },
                    ),
                    RoundedButton(
                      text: "회원가입",
                      color: Palette.kPrimaryLightColor,
                      textColor: Palette.customBlack,
                      press: () {
                        NavigatorUtils.pushPageByFade(
                            context: context, targPage: SignUpScreen(), isReplace: true);
                        },
                    ),
                  ],
                ),
              ),
            )
        )
    );
  }
}
