import 'package:untitled/models/album.dart';
import 'package:untitled/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({required this.uid});

  final CollectionReference albumsCollection =
      FirebaseFirestore.instance.collection('albums');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUserData() async {
    return await userCollection.doc(uid).set({
      'firstname': '',
      'secondname': '',
      'birthdate': DateTime.now(),
      'sex': true,
      'address': '',
      'about': '',
      'favalbum': 'DE',
      'favartist': '',
      'image': 'avatar/Без имени-3.png',
      'albums_in_fav' : 0,
      'inFavourites': [],
    });
  }

  Future updateUserData(
      String firstname,
      String secondname,
      DateTime birthdate,
      bool sex,
      String address,
      String about,
      String favalbum,
      String favartist) async {
    return await userCollection.doc(uid).update({
      'firstname': firstname,
      'secondname': secondname,
      'birthdate': birthdate,
      'sex': sex,
      'address': address,
      'about': about,
      'favalbum': favalbum,
      'favartist': favartist,
    });
  }

  Future updateUserfavAlbums(List<String> favAlbums) async {
    return await userCollection.doc(uid).update({
      'inFavourites': favAlbums,
    });
  }

  Future deleteUserData() async {
    return await userCollection.doc(uid).delete();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot<Object?> snapshot) {
    return UserData(
        uid: uid!,
        firstname: snapshot['firstname'],
        secondname: snapshot['secondname'],
        birthdate: DateTime.fromMicrosecondsSinceEpoch(
            (snapshot['birthdate'] as Timestamp).microsecondsSinceEpoch),
        sex: snapshot['sex'],
        address: snapshot['address'],
        about: snapshot['about'],
        favalbum: snapshot['favalbum'],
        favartist: snapshot['favartist'],
        image: snapshot['image'],
        favAlbums: (snapshot['inFavourites'] as List).map((item) => item as String).toList());
  }

  Stream<UserData> get userData {
    if (uid != null){
      var doc = userCollection.doc(uid);
      return Stream.fromFuture(doc.get().then((snapshot) {
        if (snapshot.exists) {
          // Преобразование снимка в объект UserData
          //UserData userData = _userDataFromSnapshot(snapshot);
          UserData user = UserData(
            uid: uid!,
            firstname: snapshot['firstname'],
            secondname: snapshot['secondname'],
              birthdate: DateTime.fromMicrosecondsSinceEpoch(
                  (snapshot['birthdate'] as Timestamp).microsecondsSinceEpoch),
              sex: snapshot['sex'],
              address: snapshot['address'],
              about: snapshot['about'],
              favalbum: snapshot['favalbum'],
              favartist: snapshot['favartist'],
              image: snapshot['image'],
              favAlbums: (snapshot['inFavourites'] as List).map((item) => item as String).toList()
          );

          return user;
        } else {
          print('Document does not exist');
          throw Exception('Document does not exist');
        }
      }));
    }else{
      return Stream.empty();
    }
  }

  List<Album> _albumListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) {
          if (doc.data() == null) {
            return null;
          } else {
            return Album(
                uid: doc.id,
                title: doc['title'],
                year: doc['year'],
                artist: doc['artist']);
          }
        })
        .where((element) => element != null)
        .cast<Album>()
        .toList();
  }

  Stream<List<Album>> get albums {
    return albumsCollection.snapshots().map(_albumListFromSnapshot);
  }
}
