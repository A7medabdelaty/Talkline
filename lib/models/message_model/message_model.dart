class MessageModel {
  String? senderId;
  String? text;
  String? dateTime;
  String? receiverId;

  MessageModel({
    this.senderId,
    this.text,
    this.dateTime,
    this.receiverId,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    text = json['text'];
    dateTime = json['dateTime'];
    receiverId = json['receiverId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'dateTime': dateTime,
      'receiverId': receiverId,
    };
  }
}
