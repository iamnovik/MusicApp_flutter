
class User {
  final String uid;

  User({required this.uid});
}

class UserData {
  final String uid;
  final String firstname;
  final String secondname;
  DateTime birthdate;
  bool sex;
  final String address;
  final String image;
  final String favalbum;
  final String favartist;
  final String about;
  final List<String> favAlbums;

  UserData({
    required this.uid,
    required this.firstname,
    required this.secondname,
    required this.birthdate,
    required this.sex,
    required this.address,
    required this.image,
    required this.favalbum,
    required this.favartist,
    required this.about,
    required this.favAlbums,
  });
}
