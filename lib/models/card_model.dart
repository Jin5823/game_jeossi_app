class CardModel {
  String gamerName;
  String playerGame;
  String postTitle;
  String postContents;
  String ownerName;
  String gameDay;
  int owner;
  bool isNoob;

  int gameHoursS;
  int gameHoursE;
  int playStyle;
  int cardId;

  List<String> cardImage = [];
  List<String> playerCommunity = [];
  List<String> playerStreamer = [];

  CardModel.fromMap(Map<String, dynamic> map) {
    this.gamerName = map["gamer_name"];
    this.playerGame = map["game_name"]['player_game'];
    this.postTitle = map["title"];
    this.postContents = map["contents"];
    this.gameDay = map["game_day"];
    this.owner = map["owner"]["id"];
    this.ownerName = map["owner"]["username"];
    this.isNoob = map["is_noob"];
    this.cardId = map["id"];

    this.gameHoursS = map["game_hours_s"];
    this.gameHoursE = map["game_hours_e"];
    this.playStyle = map["play_style"];

    map['card_img'].forEach((element) {
      this.cardImage.add(element['image']);
    });
    map['community'].forEach((element) {
      this.playerCommunity.add(element['player_community']);
    });
    map['streamer'].forEach((element) {
      this.playerStreamer.add(element['player_streamer']);
    });
  }
}
