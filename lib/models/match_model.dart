class MatchModel {
  int userId;
  String userName;

  MatchModel.fromMap(Map<String, dynamic> map) {
    this.userId = map["id"];
    this.userName = map["username"];
  }
}
