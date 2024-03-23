import 'package:untitled/models/user.dart';
import 'package:untitled/screens/authentication/authentication.dart';
import 'package:untitled/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return Authentication();
    } else {
      return Home();
    }
  }
}
