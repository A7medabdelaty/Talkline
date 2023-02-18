class PostModel {
  String? name;
  String? uId;
  String? image;
  String? postImage;
  String? text;
  String? dateTime;
  String? postId;
  //Map<String , bool>? likesMap;
  dynamic likesMap;

  PostModel({
    this.name,
    this.uId,
    this.image,
    this.postImage,
    this.text,
    this.postId,
    this.dateTime,
    this.likesMap,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
    text = json['text'];
    postId = json['postId'];
    dateTime = json['dateTime'];
    likesMap = json['likesMap'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'postImage': postImage,
      'text': text,
      'dateTime': dateTime,
      'postId': postId,
      'likesMap': likesMap,
    };
  }
}
