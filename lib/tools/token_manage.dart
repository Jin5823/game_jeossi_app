import 'package:game_jeossi_app/utils/sp_utils.dart';


class TokenHelper {
  //私有化构造函数 전용 생성자(Private Constructor)
  TokenHelper._();

  //전역대상 생성
  static TokenHelper getInstance = TokenHelper._();
  UserToken _userToken;

  // 기능 set get 로그인 여부
  bool get isLogin => _userToken != null;
  set userToken(UserToken token) {
    _userToken = token;
    SPUtil.saveObject("user_token", _userToken);
  }
  get userToken => _userToken;

  void init(){
    Map<String, dynamic> map = SPUtil.getObject("user_token");
    if(map!=null){
      // 메모리에 저장?
      _userToken= UserToken.fromMap(map);
    }
  }

  void clear(){
    _userToken = null;
    SPUtil.remove("user_token");
  }
}


class UserToken {
  String token;

  /// 매핑 형식으로 데이터 받기
  UserToken.fromMap(Map<String, dynamic> map) {
    this.token = map["token"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map["token"] = this.token;
    return map;
  }
}
