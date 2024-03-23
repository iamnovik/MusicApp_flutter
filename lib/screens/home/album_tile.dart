import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/album.dart';
import 'package:untitled/models/user.dart';
import 'package:untitled/screens/home/album_detailed.dart';
import 'package:untitled/screens/home/preview.dart';
import 'package:untitled/services/database_service.dart';
import 'package:untitled/shared/constants.dart';

class AlbumTile extends StatefulWidget {
  const AlbumTile({Key? key, required this.album, required this.userData}) : super(key: key);

  final UserData? userData;
  final Album album;

  @override
  _AlbumTileState createState() => _AlbumTileState();
}

class _AlbumTileState extends State<AlbumTile> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.album.isFav;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    void _showCarDetailed(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlbumDetailed(album: widget.album, folderPath: '${widget.album.title}/', userData: widget.userData),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(),
      child: Card(
        margin: EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 0.0),
        child: Stack(
          children: [
            // PreviewImage в качестве фона
            Positioned.fill(
              child: PreviewImage(path: '${widget.album.title}/preview.jpg'),
            ),
            InkWell(
              onTap: () {
                _showCarDetailed(context);
              },
              child: Container(// Установите желаемую высоту карточки
                child: ListTile(
                  title: Text(
                    widget.album.title,
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.red,
                      shadows: [
                        Shadow(
                          color: Colors.black, // Цвет тени
                          offset: Offset(2, 2), // Смещение тени по оси X и Y
                          blurRadius: 20, // Размытие тени
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    '${widget.album.artist}\n${widget.album.year}',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      shadows: [
                        Shadow(
                          color: Colors.black, // Цвет тени
                          offset: Offset(2, 2), // Смещение тени по оси X и Y
                          blurRadius: 20, // Размытие тени
                        ),
                      ],
                    ),
                  ),
                  trailing: SizedBox(
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        size: 50,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      // Отступы
                      onPressed: () async{

                        if (widget.userData != null) {
                          if (isFavorite) {
                            widget.userData!.favAlbums.remove(widget.album.uid);
                          } else {
                            widget.userData!.favAlbums.add(widget.album.uid);
                          }
                          await DatabaseService(uid: user!.uid)
                              .updateUserfavAlbums(widget.userData!.favAlbums);

                        }
                        setState(() {
                          isFavorite = !isFavorite;
                          widget.album.isFav = !widget.album.isFav;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
