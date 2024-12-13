import 'dart:ffi';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class userAuth {
  final auth = FirebaseAuth.instance;
  String uid = '';

  Future<User?> createUserA(String email, String pw) async {
    try {
      final userCredential =
          await auth.createUserWithEmailAndPassword(email: email, password: pw);
      uid = userCredential.user!.uid;
      return userCredential.user;
    } catch (e) {
      print("Login Unsucessful");
    }
    return null;
  }

  Future<User?> userLogin(String email, String pw) async {
    try {
      final credential =
          await auth.signInWithEmailAndPassword(email: email, password: pw);
      return credential.user;
    } catch (e) {
      print("Login Unsucessful");
    }
    return null;
  }

  static Future<void> signout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Logout Unsucessful");
    }
  }

  static String? getId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
}

class User2 {
  final String fname;
  final String lname;
  //final Timestamp dob;
  final String gender;
  //final List<String> allergies;

  User2({
    required this.fname,
    required this.lname,
    //required this.dob,
    required this.gender,
    //required this.allergies,
  });

  factory User2.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return User2(
      fname: data['Fname'] ?? '',
      lname: data['Lname'] ?? '',
      gender: data['gender'] ?? '',
      //dob: data['dob'] ?? '',
      //allergies: data['allergies'] ?? '',
    );
  }

  static Future<User2> fetchUser(String? userId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Medminder')
        .doc(userId)
        .get();
    return User2.fromFireStore(doc);
  }
}
