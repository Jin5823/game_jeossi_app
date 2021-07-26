import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class SPUtil {
  ///静态实例 static and instance?
  static SharedPreferences _sharedPreferences;

  ///앱이 실행 될때 호출되어야함?
  ///초기화
  static Future<bool> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return true;
  }

  //지우기
  static void remove(String key) async {
    if (_sharedPreferences.containsKey(key)) {
      _sharedPreferences.remove(key);
    }
  }

  // 제공하는 기본 타입 저장하기, 이게 맞나?
  static Future save(String key, dynamic value) async {
    if (value is String) {
      _sharedPreferences.setString(key, value);
    } else if (value is bool) {
      _sharedPreferences.setBool(key, value);
    } else if (value is double) {
      _sharedPreferences.setDouble(key, value);
    } else if (value is int) {
      _sharedPreferences.setInt(key, value);
    } else if (value is List<String>) {
      _sharedPreferences.setStringList(key, value);
    }
  }

  // 타입별로 읽기 (안씀)
  static Future<String> getString(String key) async {
    return _sharedPreferences.getString(key);
  }
  static Future<int> getInt(String key) async {
    return _sharedPreferences.getInt(key);
  }
  static Future<bool> getBool(String key) async {
    return _sharedPreferences.getBool(key);
  }
  static Future<double> getDouble(String key) async {
    return _sharedPreferences.getDouble(key);
  }

  ///리스트 데이터 저장
  static Future<bool> putObjectList(String key, List<Object> list) {
    ///Object list 를 string 으로 바꾸고 나서 저장
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return _sharedPreferences.setStringList(key, _dataList);
  }

  ///리스트 데이터 읽기
  ///List<Map<String,dynamic>> 형태로 받음
  static List<Map> getObjectList(String key) {
    if (_sharedPreferences == null) return null;
    List<String> dataLis = _sharedPreferences.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }

  /// json 저장
  static Future saveObject(String key, dynamic value) async {
    /// json 을 받아서 string 으로 바꿔서 저장
    _sharedPreferences.setString(key, json.encode(value));
  }

  /// json 대상 받기
  /// Map<String,dynamic> 형태로 받음 자세한건 convert 파일 읽어보자
  static dynamic getObject(String key) {
    String _data = _sharedPreferences.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }
}
