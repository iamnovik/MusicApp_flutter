import 'package:untitled/models/album.dart';
import 'package:untitled/screens/home/album_list.dart';
import 'package:untitled/screens/home/favourites.dart';
import 'package:untitled/screens/home/profile.dart';
import 'package:untitled/screens/wrapper.dart';
import 'package:untitled/services/authentication_service.dart';
import 'package:untitled/services/database_service.dart';
import 'package:untitled/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Album>>.value(
        value: DatabaseService(uid: null).albums,
        initialData: [],
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text('Альбомы'),
              backgroundColor: Colors.black,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Intro'),
              automaticallyImplyLeading: false,
              actionsIconTheme: IconThemeData(),
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                    onPressed:(){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Settings()));
                    },
                    icon: Icon(
                      Icons.account_circle,
                      color: Colors.red,
                    )
                ),
                IconButton(
                    onPressed:(){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Favourites()));
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                ),
                IconButton(
                    onPressed:(){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Wrapper()));
                    },
                    icon: Icon(
                      Icons.list,
                      color: Colors.red,
                    )
                )
              ],
            ),
            body: Container(
                decoration: BoxDecoration(color: backgroundColor),
                child: AlbumList(onlyFavourites: false,)),
          );
        });
  }
}
