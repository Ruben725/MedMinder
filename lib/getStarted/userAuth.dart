import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class userAuth{
  final auth = FirebaseAuth.instance;

  Future<User?> createUserA(String email, String pw) async{
    try{
    final userCredential = await auth.createUserWithEmailAndPassword(email: email, password: pw);
    String uid = userCredential.user!.uid;
    return userCredential.user;
    }catch(e){
        print("Login Unsucessful");
    }
    return null;
  }

  Future<User?> userLogin(String email, String pw) async{
    try{
    final credential = await auth.signInWithEmailAndPassword(email: email, password: pw);
    return credential.user;
    }catch(e){
        print("Login Unsucessful");
    }
    return null;
  }

  Future<void> signout() async{
    try{
      await auth.signOut();
    }catch(e){
      print("Logout Unsucessful");
    }
  }
}