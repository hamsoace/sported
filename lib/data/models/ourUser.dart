import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String username;
  final String email;
  final String avatarUrl;

  const UserModel({this.uid, this.username, this.email, this.avatarUrl});

  static const empty = UserModel(email: '', uid: '', username: "", avatarUrl: "");

  Map toMap(UserModel user) {
    var data = Map<String, dynamic>();

    data["uid"] = user.uid;
    data["username"] = user.username;
    data["email"] = user.email;
    data["avatar"] = user.avatarUrl;

    return data;
  }

  @override
  List<Object> get props => [
        uid,
        username,
        email,
        avatarUrl,
      ];

  // UserModel.fromMap(Map<String, dynamic> mapData) {
  //   this.uid = mapData["uid"];
  //   this.username = mapData["username"];
  //   this.email = mapData["email"];
  //   this.avatarUrl = mapData['avatar'];
  // }

}
