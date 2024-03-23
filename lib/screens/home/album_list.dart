import 'package:untitled/models/album.dart';
import 'package:untitled/models/user.dart';
import 'package:untitled/screens/home/album_tile.dart';
import 'package:untitled/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumList extends StatefulWidget {
  const AlbumList({super.key, required this.onlyFavourites});

  final bool onlyFavourites;

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  Widget build(BuildContext context) {
    final bool onlyFavourites = widget.onlyFavourites;

    final user = Provider.of<User?>(context);
    final albums = Provider.of<List<Album>>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
        // Показываем индикатор загрузки или другое заглушающее содержимое
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
        // Если произошла ошибка при получении данных, показываем сообщение об ошибке
          return Text('Ошибка загрузки данных ${snapshot.error}');
        } else if (!snapshot.hasData) {
        // Если данные не загружены, показываем заглушающее содержимое
          return Text('Данные не загружены');
        } else {
          UserData? userData;
          if (snapshot.hasData) {
            userData = snapshot.data!;
            for (Album album in albums) {
              if (userData!.favAlbums.any((element) => element == album.uid)) {
                album.isFav = true;
              } else {
                album.isFav = false;
              }
            }
          }

          if(onlyFavourites){
            albums.removeWhere((album) => !album.isFav);
          }

          return ListView.builder(
              itemCount: albums.length,
              itemBuilder: (context, index) {
                return AlbumTile(album: albums[index], userData: userData);
              });
        }});
  }
}
