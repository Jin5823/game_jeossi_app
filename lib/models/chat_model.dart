class ChatModel {
  int messageId;
  int sender;
  int receiver;
  String message;
  DateTime timestamp;

  ChatModel.fromMap(Map<String, dynamic> map) {
    this.messageId = map["id"];
    this.sender = map["sender"];
    this.receiver = map["receiver"];
    this.message = map["message"];
    this.timestamp = DateTime.parse(map["timestamp"]);
  }
}
