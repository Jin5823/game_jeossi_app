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
import 'package:email_validator/email_validator.dart';
import 'package:game_jeossi_app/widgets/welcome_widgets.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}


class _SignUpScreenState extends State<SignUpScreen> {
  FocusNode _userEmailFocusNode = new FocusNode();
  FocusNode _userNameFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();
  FocusNode _confirmPasswordFocusNode = new FocusNode();

  TextEditingController _userEmailEditController = new TextEditingController();
  TextEditingController _userNameEditController = new TextEditingController();
  TextEditingController _userPasswordEditController = new TextEditingController();
  TextEditingController _confirmPasswordEditController = new TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

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
                  _userNameFocusNode.unfocus();
                  _passwordFocusNode.unfocus();
                  _confirmPasswordFocusNode.unfocus();
                  },

                child: SignUpBackground(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: size.height * 0.03),
                        SvgPicture.asset(
                          "assets/icons/signup.svg",
                          height: size.height * 0.35,
                        ),

                        // 이메일
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
                              FocusScope.of(context).requestFocus(_userNameFocusNode);
                            },
                          ),
                        ),

                        // 닉네임
                        TextFieldContainer(
                          child: TextField(
                            cursorColor: Palette.kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Palette.kPrimaryColor,
                              ),
                              hintText: "닉네임",
                              border: InputBorder.none,
                            ),

                            focusNode: _userNameFocusNode,
                            controller: _userNameEditController,
                            onSubmitted: (value) {
                              // _userNameFocusNode.unfocus();
                              FocusScope.of(context).requestFocus(_passwordFocusNode);
                            },
                          ),
                        ),

                        // 비밀 번호
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
                              // _passwordFocusNode.unfocus();
                              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                            },
                            focusNode: _passwordFocusNode,
                            controller: _userPasswordEditController,
                          ),
                        ),

                        // 비번 화인
                        TextFieldContainer(
                          child: TextField(
                            obscureText: _hideConfirmPassword,
                            cursorColor: Palette.kPrimaryColor,
                            decoration: InputDecoration(
                              hintText: "암호 확인",
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.check_circle,
                                color: Palette.kPrimaryColor,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _hideConfirmPassword = !_hideConfirmPassword;
                                  });
                                },
                                child: Icon(
                                  _hideConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                  color: Palette.kPrimaryColor,
                                ),
                              ),
                            ),

                            onSubmitted: (value){
                              // _userEmailFocusNode.unfocus();
                              // _passwordFocusNode.unfocus();
                              submitFunction();
                            },
                            focusNode: _confirmPasswordFocusNode,
                            controller: _confirmPasswordEditController,
                          ),
                        ),

                        RoundedButton(
                          text: "회원가입",
                          press: () {
                            submitFunction();
                            },
                        ),

                        SizedBox(height: size.height * 0.03),
                        AlreadyHaveAnAccountCheck(
                          login: false,
                          press: () {
                            NavigatorUtils.pushPageByFade(
                                context: context, targPage: LoginScreen(), isReplace: true);
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
    String userName = _userNameEditController.text;
    String password = _userPasswordEditController.text;
    String password2 = _confirmPasswordEditController.text;

    if (!EmailValidator.validate(userEmail)) {
      ToastUtils.showToast("이메일 확인해줘잉");
      return;
    }
    if (userName.trim().length < 1) {
      ToastUtils.showToast("사용자 이름을 확인해줘잉");
      return;
    }
    if (password.trim().length < 1) {
      ToastUtils.showToast("비밀번호 확인 해줘잉");
      return;
    }
    if (password2.trim().length < 1) {
      ToastUtils.showToast("비밀번호 확인 해줘잉");
      return;
    }
    if (password2 != password) {
      ToastUtils.showToast("비밀번호 불일치");
      return;
    }

    Map<String, dynamic> map = {
      "email": userEmail,
      "username": userName,
      "password": password,
      "password2": password2,
    };

    // post 요청 로그인
    ResponseInfo responseInfo = await DioUtils.instance.postRequest(
      url: ApiUrl.registerUrl,
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
        ToastUtils.showToast(responseInfo.data['error_message']);
      }
    } else {
      ToastUtils.showToast("${responseInfo.message}");
      // ToastUtils.showToast("송신 에러 ㅈㅅ");
    }
  }
}
