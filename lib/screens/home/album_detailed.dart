import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/models/album.dart';
import 'package:untitled/models/user.dart';
import 'package:untitled/screens/home/preview.dart';
import 'package:untitled/shared/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:untitled/services/database_service.dart';

import 'package:flutter/material.dart';

import '../wrapper.dart';

class AlbumDetailed extends StatefulWidget {
  const AlbumDetailed({Key? key, required this.album, required this.folderPath, required this.userData}) : super(key: key);

  final String folderPath;
  final Album album;
  final UserData? userData;
  @override
  _AlbumDetailedState createState() => _AlbumDetailedState();
}

class _AlbumDetailedState extends State<AlbumDetailed> {
  late Future<List<String>> _futureResult;
  late bool isFavourite;
  @override
  void initState() {
    super.initState();
    _futureResult = _getDetailedFilesUrl(widget.folderPath);
    isFavourite = widget.album.isFav;
  }

  Future<List<String>> _getDetailedFilesUrl(String firebasePath) async {
    try {
      List<String> result = [];
      final files =
      await FirebaseStorage.instance.ref(firebasePath).listAll();

      for (var file in files.items) {
        result.add(await file.getDownloadURL());
      }
      return result;
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    var result = _getDetailedFilesUrl(widget.folderPath);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton( // Добавляем кнопку "назад"
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white,),
            onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wrapper()));


            },
          ),
        ),
        backgroundColor: backgroundColor,
        body: SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                  padding: EdgeInsets.only(top:40),
                  child: Form(
                    key: widget.key,
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          child: PreviewImage(path: '${widget.album.title}/preview.jpg'),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left:20),
                          child: Text(
                              widget.album.title,
                              style: TextStyle(fontSize: 40, color: Colors.red)
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left:20),
                          child: Text(
                              widget.album.artist,
                              style: TextStyle(fontSize: 30, color: Colors.red)
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left:20),
                          child: Text(
                              widget.album.year.toString(),
                              style: TextStyle(fontSize: 30, color: Colors.red)
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 400,
                          child: FutureBuilder(
                            future: result,
                            builder:
                                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                  return CarouselSlider(
                                    options: CarouselOptions(height: 400, viewportFraction: 1.0),
                                    items: snapshot.data!.map((url) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: CachedNetworkImageProvider(url), // используйте CachedNetworkImageProvider для загрузки изображения по URL
                                                fit: BoxFit.cover, // растягиваем изображение на всю площадь контейнера
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  );
                                } else if (snapshot.error != null || snapshot.data!.isEmpty) {
                                  return Image.asset('assets/logo.png', height: 150);
                                }
                              }
                              return Image.asset('assets/logo.png', height: 150);},
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: ()  async{
                            if (widget.userData != null) {
                              if (isFavourite) {
                                widget.userData!.favAlbums.remove(widget.album.uid);
                              } else {
                                widget.userData!.favAlbums.add(widget.album.uid);
                              }
                              await DatabaseService(uid: widget.userData?.uid)
                                  .updateUserfavAlbums(widget.userData!.favAlbums);
                              setState(() {
                                  isFavourite = !isFavourite;
                              });
                            }
                          },
                          child: Container(
                            width: 300,
                            height: 65,// Ширина кнопки
                            decoration: BoxDecoration(
                              color: isFavourite ? Colors.green : Color(0xFFEC0033), // Цвет фона кнопки// Скругление углов
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Цвет тени
                                  spreadRadius: 3, // Распространение тени
                                  blurRadius: 5, // Размытие тени
                                  offset: Offset(0, 2), // Смещение тени по оси X и Y
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                isFavourite ? 'Удалить из избранного' : 'Добавить в избранное' ,
                                textAlign: TextAlign.center,// Текст кнопки
                                style: TextStyle(
                                  color: Colors.black, // Цвет текста кнопки
                                  fontSize: 23, // Размер текста кнопки
                                  fontWeight: FontWeight.bold, // Жирный шрифт
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            )
        )
    );
  }
}

