import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:game_jeossi_app/tools/token_manage.dart';


class DioUtils {
  Dio _dio;

  // 펙토리 모드
  // A factory constructor can check if it has a prepared reusable instance
  // in an internal cache and return this instance or otherwise create a new one.
  factory DioUtils() => _getInstance();
  static DioUtils get instance => _getInstance();
  static DioUtils _instance;

  static DioUtils _getInstance() {
    if (_instance == null) {
      _instance = new DioUtils._internal();
    }
    return _instance;
  }

  DioUtils._internal() {
    BaseOptions options = new BaseOptions();
    options.connectTimeout = 20000;
    options.receiveTimeout = 2 * 60 * 1000;
    options.sendTimeout = 2 * 60 * 1000;
    // 초기화 옵션 설정
    _dio = new Dio(options);
  }

  Future<BaseOptions> buildOptions(BaseOptions options) async {
    /// header  추가 토큰 있을 경우 자동으로 추가해서 요청
    // options.headers["content-type"]="application/json";
    if (TokenHelper.getInstance.userToken != null){
      options.headers["authorization"]="Token "+TokenHelper.getInstance.userToken.token;
    }

    return Future.value(options);
  }

  Future<ResponseInfo> errorController(e, StackTrace s) {
    ResponseInfo responseInfo = ResponseInfo.error();
    // 이게 맞나 ?
    if (e is DioError) {
      DioError dioError = e;
      switch (dioError.type) {
        case DioErrorType.connectTimeout:
          responseInfo.message = "CONNECT_TIMEOUT_ERR";
          break;
        case DioErrorType.sendTimeout:
          responseInfo.message = "SEND_TIMEOUT_ERR";
          break;
        case DioErrorType.receiveTimeout:
          responseInfo.message = "RECEIVE_TIMEOUT_ERR";
          break;
        case DioErrorType.response:
          responseInfo.message = "RESPONSE_ERR";
          break;
        case DioErrorType.cancel:
          responseInfo.message = "CANCEL_ERR";
          break;
        case DioErrorType.other:
          responseInfo.message = "DEFAULT_ERR";
          break;
      }
    } else {
      responseInfo.message = "Error";
    }
    return Future.value(responseInfo);
  }


  /// get 메소드
  ///[url] 주소
  ///[queryParameters] 파라미터
  ///[cancelTag] 요청 캔슬 태그
  // ignore: missing_return
  Future<ResponseInfo> getRequest(
      {@required String url,
        Map<String, dynamic> queryParameters,
        CancelToken cancelTag}) async {

    try {
      _dio.options = await buildOptions(_dio.options);
      Response response = await _dio.get(url,
          queryParameters: queryParameters, cancelToken: cancelTag);
      // dio 요청
      if (response.data is Map<String, dynamic>) {
        if (response.statusCode == 200) {
          return ResponseInfo(data: response.data);
        } else {
          return ResponseInfo.error(code: response.statusCode);
        }
      }
    } catch (e, s) {
      return errorController(e, s);
    }
  }

  /// post 메소드
  ///[url] 주소
  ///[formDataMap]formData
  ///[jsonMap] JSON
  // ignore: missing_return
  Future<ResponseInfo> postRequest(
      {@required String url,
        Map<String, dynamic> formDataMap,
        Map<String, dynamic> jsonMap, CancelToken cancelTag}) async {

    FormData form;
    if (formDataMap != null) {
      form = FormData.fromMap(formDataMap);
    }
    _dio.options = await buildOptions(_dio.options);
    //post 요청
    try {
      Response response = await _dio.post(url,
          data: form == null ? jsonMap : form,
          cancelToken: cancelTag);

      if (response.data is Map<String, dynamic>) {
        if (response.statusCode == 200) {
          return ResponseInfo(data: response.data);
        } else {
          return ResponseInfo.error(code: response.statusCode);
        }
      }
    } catch (e, s) {
      return errorController(e, s);
    }
  }

  /// put 메소드
  ///[url] 주소
  ///[formDataMap]formData
  ///[jsonMap] JSON
  // ignore: missing_return
  Future<ResponseInfo> putRequest(
      {@required String url,
        Map<String, dynamic> formDataMap,
        Map<String, dynamic> jsonMap, CancelToken cancelTag}) async {

    FormData form;
    if (formDataMap != null) {
      form = FormData.fromMap(formDataMap);
    }
    _dio.options = await buildOptions(_dio.options);
    //post 요청
    try {
      Response response = await _dio.put(url,
          data: form == null ? jsonMap : form,
          cancelToken: cancelTag);

      if (response.data is Map<String, dynamic>) {
        if (response.statusCode == 200) {
          return ResponseInfo(data: response.data);
        } else {
          return ResponseInfo.error(code: response.statusCode);
        }
      }
    } catch (e, s) {
      return errorController(e, s);
    }
  }

  /// delete 메소드
  ///[url] 주소
  ///[formDataMap]formData
  ///[jsonMap] JSON
  // ignore: missing_return
  Future<ResponseInfo> deleteRequest(
      {@required String url,
        Map<String, dynamic> formDataMap,
        Map<String, dynamic> jsonMap, CancelToken cancelTag}) async {

    FormData form;
    if (formDataMap != null) {
      form = FormData.fromMap(formDataMap);
    }
    _dio.options = await buildOptions(_dio.options);
    //post 요청
    try {
      Response response = await _dio.delete(url,
          data: form == null ? jsonMap : form,
          cancelToken: cancelTag);
      if (response.data is Map<String, dynamic>) {
        if (response.statusCode == 200) {
          return ResponseInfo(data: response.data);
        } else {
          return ResponseInfo.error(code: response.statusCode);
        }
      }
    } catch (e, s) {
      return errorController(e, s);
    }
  }
}


class ResponseInfo {
  bool success;
  int code;
  String message;
  dynamic data;

  ResponseInfo(
      {this.success = true,
        this.code = 200,
        this.data,
        this.message = "SUCCESS"});

  ResponseInfo.error(
      {this.success = false,
        this.code = 201,
        this.message = "FAIL"});
}
