import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/models/user.dart';
import 'package:untitled/screens/home/favourites.dart';
import 'package:untitled/screens/home/preview.dart';
import 'package:untitled/screens/wrapper.dart';
import 'package:untitled/services/authentication_service.dart';
import 'package:untitled/services/database_service.dart';
import 'package:untitled/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();


}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthenticationService();

  late TextEditingController _favAlbumController;
  late TextEditingController _favArtistController;
  late TextEditingController _firstnameController;
  late TextEditingController _secondnameController;
  late TextEditingController _addressController;
  late TextEditingController _aboutController;


  @override
  void initState() {
    super.initState();
    _favAlbumController = TextEditingController();
    _favArtistController = TextEditingController();
    _firstnameController = TextEditingController();
    _secondnameController = TextEditingController();
    _addressController = TextEditingController();
    _aboutController = TextEditingController();
  }

  @override
  void dispose() {
    _favAlbumController.dispose();
    _favArtistController.dispose();
    _firstnameController.dispose();
    _secondnameController.dispose();
    _addressController.dispose();
    _aboutController.dispose();// Не забудьте освободить ресурсы контроллера
    super.dispose();
  }
  String? _firstname;
  String? _secondname;
  bool? _sex;
  String? _address;
  DateTime? _birthdate;
  String? _favartist;
  String? _favalbum;
  String? _about;
  Future selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthdate = picked);
    }
  }
  @override
  Widget build(BuildContext context) {


    final user = Provider.of<User?>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data!;
            _favAlbumController.text = _favalbum ?? userData.favalbum;
            _favArtistController.text = _favartist ?? userData.favartist;
            _secondnameController.text = _secondname ?? userData.secondname;
            _firstnameController.text = _firstname ?? userData.firstname;
            _aboutController.text = _about ?? userData.about;
            _addressController.text = _address ?? userData.address;
            return Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                title: Text('Профиль'),
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: ClipRRect(
                              child: PreviewImage(
                                path: userData.image // режим заполнения изображения
                              ),
                            ),
                          ),

                          SizedBox(width: 30,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              SizedBox(
                                width: 250,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Введите имя',
                                  ),
                                  controller: _firstnameController, // установка начального значения
                                  onChanged: (value) {
                                    setState(() {
                                      _firstname = value; // обновление переменной при изменении текста
                                    });
                                  },
                                ),

                              ),
                              SizedBox(
                                width: 250,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Введите фамилию',
                                  ),
                                  controller: _secondnameController, // установка начального значения
                                  onChanged: (value) {
                                    setState(() {
                                      _secondname = value; // обновление переменной при изменении текста
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'О себе',
                                  ),
                                  maxLines: null,
                                  controller: _aboutController, // установка начального значения
                                  onChanged: (value) {
                                    setState(() {
                                      _about = value; // обновление переменной при изменении текста
                                    });
                                  },
                                ),
                              )
                            ]
                          )

                        ]
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Text(
                            'Женщина',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          Switch(
                            value: _sex ?? userData.sex, // ваше значение
                            onChanged: (bool value) {
                              setState(() {
                                print(_sex);
                                userData.sex = value;
                                _sex = value;
                                print(_sex);
                              });
                              //_sex = value;
                            },
                          ),
                          Text(
                            'Мужчина',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          SizedBox(width: 10,),
                          Text(
                            'В избранном:',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            userData.favAlbums.length.toString(),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.0),

                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(Colors.transparent), // Удаление эффекта нажатия
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black, // Цвет подчёркивания
                                    width: 1, // Ширина подчёркивания
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                      DateFormat('dd.MM.yyyy').format(
                                          _birthdate ?? userData.birthdate),
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black)),
                                ],
                              )
                              ,
                            ),
                            onPressed: () => selectDate(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          decoration: InputDecoration(

                            hintText: 'Введите адрес',
                          ),
                          controller: _addressController, // установка начального значения
                          onChanged: (value) {
                            setState(() {
                              _address = value; // обновление переменной при изменении текста
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 20.0),
                      Center(
                        child: Text(
                          'Предпочтения',
                            style: TextStyle(
                                fontSize: 25, color: Colors.black)
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          SizedBox(
                            width: 180,
                            child: Text(
                                'Любимый артист',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Введите артиста',
                              ),
                              controller: _favArtistController, // установка начального значения
                              onChanged: (value) {
                                setState(() {
                                  _favartist = value; // обновление переменной при изменении текста
                                });
                              },
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          SizedBox(
                            width: 180,
                            height: 100,
                            child: Text(
                                'Любимый альбом',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            height: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Введите альбом',
                              ),
                              controller: _favAlbumController, // установка начального значения
                              onChanged: (value) {
                                setState(() {
                                  _favalbum = value; // обновление переменной при изменении текста
                                });
                              },
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {

                                await DatabaseService(uid: user?.uid)
                                    .updateUserData(
                                    _firstname ?? userData.firstname,
                                    _secondname ?? userData.secondname,
                                    _birthdate ?? userData.birthdate,
                                    _sex ?? userData.sex,
                                    _address ?? userData.address,
                                    _about ?? userData.about,
                                    _favartist ?? userData.favartist,
                                    _favalbum ?? userData.favalbum);



                            },
                            child: Container(
                              width: 160,
                              height: 40,// Ширина кнопки
                              decoration: BoxDecoration(
                                color: Colors.grey, // Цвет фона кнопки// Скругление углов
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
                                  'Cохранить',
                                  textAlign: TextAlign.center,// Текст кнопки
                                  style: TextStyle(
                                    color: Colors.black, // Цвет текста кнопки
                                    fontSize: 20, // Размер текста кнопки
                                    fontWeight: FontWeight.bold, // Жирный шрифт
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _auth.signOut();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Wrapper()));
                            },
                            child: Container(
                              width: 160,
                              height: 40,// Ширина кнопки
                              decoration: BoxDecoration(
                                color: Colors.grey, // Цвет фона кнопки// Скругление углов
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
                                  'Выйти',
                                  textAlign: TextAlign.center,// Текст кнопки
                                  style: TextStyle(
                                    color: Colors.black, // Цвет текста кнопки
                                    fontSize: 20, // Размер текста кнопки
                                    fontWeight: FontWeight.bold, // Жирный шрифт
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        });
  }
}
