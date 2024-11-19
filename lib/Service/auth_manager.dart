import 'package:flutter/material.dart';
import '../View/Screens/home_screen.dart';
import '../View/Screens/sign_in.dart';
import '../View/Screens/splash_screen.dart';
import 'auth_service.dart';

class AuthManager extends StatelessWidget {
  const AuthManager({super.key});



  @override
  Widget build(BuildContext context) {
    return (AuthService.authService.getUser() == null)
        ?  SignIn()
        :  HomeScreen();
  }
}


