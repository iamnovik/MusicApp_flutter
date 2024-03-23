import 'package:untitled/screens/authentication/registration.dart';
import 'package:untitled/screens/wrapper.dart';
import 'package:untitled/services/authentication_service.dart';
import 'package:untitled/shared/constants.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top:60),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/logo.png', height: 160),
                  SizedBox(height: 70),
                  Text('Войдите', style: TextStyle(fontSize: 30, color: Colors.black)),
                  SizedBox(height: 80),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Введите логин',
                        hintStyle: TextStyle(color:Colors.black, fontSize: 20),
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() => email = value);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: 'Введите пароль',
                        hintStyle: TextStyle(color:Colors.black, fontSize: 20),
                        border: UnderlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null ) {
                          return 'Пароль должен содержать минимум 8 символов';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() => password = value);
                      },
                    ),
                  ),
                  SizedBox(height: 100),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if (result == null) {
                          setState(() => error = 'Неправильный email или пароль');
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
                        }
                        setState(() => loading = false);
                      }
                    },
                    child: Container(
                      width: 300,
                      height: 60,// Ширина кнопки
                      decoration: BoxDecoration(
                        color: Color(0xFFEC0033), // Цвет фона кнопки// Скругление углов
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
                          'Войти', // Текст кнопки
                          style: TextStyle(
                            color: Colors.black, // Цвет текста кнопки
                            fontSize: 30, // Размер текста кнопки
                            fontWeight: FontWeight.bold, // Жирный шрифт
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                    },
                    child: Text('Зарегистрироваться', style: TextStyle(color: Color(0xFF6464F3))),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    error,
                    style: TextStyle(color: accentColor, fontSize: 14.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
