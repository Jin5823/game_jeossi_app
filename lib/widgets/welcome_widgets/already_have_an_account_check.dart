import 'package:flutter/material.dart';
import 'package:game_jeossi_app/config/palette.dart';


class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "계정이 없나요 ? " : "이미 계정이 있나요 ? ",
          style: TextStyle(color: Palette.kPrimaryColor),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? " 회원가입" : " 로그인",
            style: TextStyle(
              color: Palette.kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
