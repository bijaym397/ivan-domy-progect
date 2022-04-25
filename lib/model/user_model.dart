class UserModel {
  String? uid;
  String? email;
  String? name;
  String? phoneNo;
  String? userImage;

  UserModel({this.uid, this.email, this.name, this.phoneNo, this.userImage});

  factory UserModel.fromMap(map){
    return UserModel(
      uid: map["uid"],
      email: map["email"],
      name: map["name"],
      phoneNo: map["phoneNo"],
      userImage: map["userImage"],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "phoneNo": phoneNo,
      "userImage": userImage,
    };
  }

}
