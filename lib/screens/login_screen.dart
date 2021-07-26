import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/config/api_urls.dart';
import 'package:game_jeossi_app/screens/screens.dart';
import 'package:game_jeossi_app/utils/dio_utils.dart';
import 'package:game_jeossi_app/utils/toast_utils.dart';
import 'package:game_jeossi_app/tools/token_manage.dart';
import 'package:game_jeossi_app/utils/navigator_utils.dart';
import 'package:game_jeossi_app/widgets/welcome_widgets.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  FocusNode _passwordFocusNode = new FocusNode();
  FocusNode _userEmailFocusNode = new FocusNode();

  TextEditingController _userEmailEditController = new TextEditingController();
  TextEditingController _userPasswordEditController = new TextEditingController();

  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: GestureDetector(
                onTap: () {
                  _userEmailFocusNode.unfocus();
                  _passwordFocusNode.unfocus();
                },
                child: LoginBackground(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: size.height * 0.03),
                        SvgPicture.asset(
                          "assets/icons/login.svg",
                          height: size.height * 0.35,
                        ),
                        SizedBox(height: size.height * 0.03),

                        // 아이디
                        TextFieldContainer(
                          child: TextField(
                            cursorColor: Palette.kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.email,
                                color: Palette.kPrimaryColor,
                              ),
                              hintText: "이메일",
                              border: InputBorder.none,
                            ),

                            focusNode: _userEmailFocusNode,
                            controller: _userEmailEditController,
                            onSubmitted: (value) {
                              // _userEmailFocusNode.unfocus();
                              FocusScope.of(context).requestFocus(_passwordFocusNode);
                              },
                          ),
                        ),

                        // 비번
                        TextFieldContainer(
                          child: TextField(
                            obscureText: _hidePassword,
                            cursorColor: Palette.kPrimaryColor,
                            decoration: InputDecoration(
                              hintText: "암호",
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.lock,
                                color: Palette.kPrimaryColor,
                              ),

                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                  },
                                child: Icon(
                                  _hidePassword ? Icons.visibility : Icons.visibility_off,
                                  color: Palette.kPrimaryColor,
                                ),
                              ),
                            ),

                            onSubmitted: (value){
                              // _userEmailFocusNode.unfocus();
                              // _passwordFocusNode.unfocus();
                              submitFunction();
                            },
                            focusNode: _passwordFocusNode,
                            controller: _userPasswordEditController,
                          ),
                        ),

                        RoundedButton(
                          text: "로그인",
                          press: () {
                            submitFunction();
                            },
                        ),

                        SizedBox(height: size.height * 0.03),
                        AlreadyHaveAnAccountCheck(
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
        )
    );
  }

  void submitFunction() async {
    String userEmail = _userEmailEditController.text;
    String password = _userPasswordEditController.text;

    if (userEmail.trim().length < 1) {
      ToastUtils.showToast("사용자 이름을 확인해줘잉");
      return;
    }
    if (password.trim().length < 1) {
      ToastUtils.showToast("비밀번호 확인 해줘잉");
      return;
    }

    Map<String, dynamic> map = {
      "email": userEmail,
      "password": password,
    };

    // post 요청 로그인
    ResponseInfo responseInfo = await DioUtils.instance.postRequest(
      url: ApiUrl.loginUrl,
      formDataMap: map,
    );

    if (responseInfo.success) {
      if (responseInfo.data['token'] != null){
        // 데이터 스크립
        UserToken userToken = UserToken.fromMap(responseInfo.data);
        // 메모리와 디스크에 저장 버퍼
        TokenHelper.getInstance.userToken = userToken;

        // 이동
        NavigatorUtils.pushPageByFade(
            context: context, targPage: NavScreen(), isReplace: true);
      } else {
        ToastUtils.showToast("님 아이디랑 비번 확인좀");
      }
    } else {
      ToastUtils.showToast("${responseInfo.message}");
      // ToastUtils.showToast("송신 에러 ㅈㅅ");
    }
  }
}
