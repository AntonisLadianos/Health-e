// ignore_for_file: non_constant_identifier_names

class UserModel {
  late int id;
  late String first_name;
  late String last_name;
  late String email;
  late String date_of_birth;
  late String mpassword;
  late String profileimg;

  UserModel(
    this.first_name,
    this.last_name,
    this.email,
    this.date_of_birth,
    this.mpassword,
    this.profileimg,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'date_of_birth': date_of_birth,
      'password': mpassword,
      'profile_photo': profileimg,
    };
    return map;
  }

  UserModel.formMap(Map<String, dynamic> map) {
    first_name = map['first_name'];
    last_name = map['last_name'];
    email = map['email'];
    date_of_birth = map['date_of_birth'];
    mpassword = map['password'];
    profileimg = map['profile_photo'];
  }
}
