class CommentModel {
  String? name;
  String? uId;
  String? image;
  String? text;

  CommentModel({
    this.name,
    this.uId,
    this.image,
    this.text,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    text = json['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'text': text,
    };
  }
}
