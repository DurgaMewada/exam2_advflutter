import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static AuthService authService = AuthService._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> createAccountUsingEmailandPassword(String email, String password )
  async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }


  Future<void> signInWithUsingEmailandPassword(String email ,String password)
  async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  
  Future<void> signOutUser()
  async {
    await _firebaseAuth.signOut();
  }


  User? getUser()
  {
    User? user = _firebaseAuth.currentUser;
    if(user!=null)
    {
      log("Email = ${user.email}");

    }
    return user;
  }


}
