import 'package:exam2_advflutter/View/Screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/auth_controller.dart';
import '../../Service/auth_service.dart';
import 'home_screen.dart';




class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    return Scaffold(
      backgroundColor: const Color(0xff0d0603),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d0603),
        title: const Text('Sign In',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: 800,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
               ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    TextField(
                      controller: authController.txtEmail,
                      decoration: InputDecoration(
                          label: const Text('Email'),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: authController.txtPassword,
                      decoration: InputDecoration(
                          label: const Text('Password'),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp(),));
                      },
                      child: const Text('Dont have any Account ? '),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await AuthService.authService.signInWithUsingEmailandPassword(authController.txtEmail.text, authController.txtPassword.text);
                          User? user = AuthService.authService.getUser();
                          if (user != null) {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(),));
                          } else {
                          }
                        },
                        child: const Text('Sign In')),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
