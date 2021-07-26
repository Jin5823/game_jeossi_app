class ApiUrl {
  static const String port = '';
  static const String apiPath = '/Api';
  static const String rootUrl = 'http://15.165.95.185'+port;
  static const String apiUrl = rootUrl+apiPath;

  static const String loginUrl = apiUrl+'/login';
  static const String registerUrl = apiUrl+'/register';
  static const String listUrl = apiUrl+'/list';
  static const String deleteUrl = apiUrl+'/delete';
  static const String createUrl = apiUrl+'/create';
  static const String matchUrl = apiUrl+'/match';
  static const String unmatchUrl = apiUrl+'/unmatch';
  static const String infoUrl = apiUrl+'/info';

  static const String messagesUrl = apiUrl+'/messages';
  static const String sendUrl = apiUrl+'/send';
  static const String likeUrl = apiUrl+'/like';
}
