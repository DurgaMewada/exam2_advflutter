import 'dart:async';

import 'package:exam2_advflutter/Service/auth_manager.dart';
import 'package:exam2_advflutter/View/Screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 3),
          () => Get.to(SignIn()),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://cdn0.iconfinder.com/data/icons/glyph-user-group-icon-set-1-ibrandify/512/37-512.png'))),
            )
          ],
        ),
      ),
    );
  }
}