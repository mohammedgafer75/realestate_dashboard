import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestResult {
  dynamic data;
  int ch;
  RequestResult(this.data, this.ch);
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final CollectionReference realestate =
    FirebaseFirestore.instance.collection('realestate');
Future<RequestResult> signInwithEmailAndPassword2(
  String email,
  String password,
) async {
  late String msg;
  try {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return RequestResult(credential.user, 1);
  } on auth.FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      msg = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      msg = 'Wrong password provided for that user.';
    }

    return RequestResult(msg, 0);
  }
}

Future<RequestResult> CreateUserwithEmailAndPassword(
  String email,
  String password,
) async {
  late String msg;
  try {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return RequestResult(credential, 1);
  } on auth.FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      msg = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      msg = 'The account already exists for that email.';
    }
    return RequestResult(msg, 0);
  }
}

Future<RequestResult> saveAdmin({
  required String aid,
  required String name,
  required int number,
  required String email,
  required int aprrov,
}) async {
  Map<String, dynamic> data = <String, dynamic>{
    "uid": aid,
    "name": name,
    "phone": number,
    "email": email,
    "aprrov": aprrov,
  };
  try {
    var res =
        await FirebaseFirestore.instance.collection('Admin').doc().set(data);
    return RequestResult("Admin added to the database", 1);
  } catch (e) {
    return RequestResult(e, 0);
  }
}

// Future<RequestResult> saveLocation({
//   required String rid,
//   required Location location,
// }) async {
//   Map<String, dynamic> data = <String, dynamic>{
//     "rid": rid,
//     "location": location,
//   };
//   try {
//     var res =
//         await FirebaseFirestore.instance.collection('Location').doc().set(data);
//     return RequestResult("Loaction added to the database", 1);
//   } catch (e) {
//     return RequestResult(e, 0);
//   }
// }
