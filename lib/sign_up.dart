import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rs_admin/http.dart';
import 'package:rs_admin/text_field_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

TextEditingController email = TextEditingController();
TextEditingController name = new TextEditingController();
TextEditingController password = new TextEditingController();
TextEditingController number = new TextEditingController();

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reqister'),
      ),
      backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 90.0, left: 20, right: 20),
          child: ListView(
            children: [
              TextInputField(
                  icon: Icons.email,
                  hint: 'Email',
                  controller: email,
                  msg: 'please enter your email'),
              TextInputField(
                  icon: Icons.person,
                  hint: 'Name',
                  controller: name,
                  msg: 'please enter your name'),
              TextInputField(
                  icon: Icons.phone,
                  hint: 'phone',
                  controller: number,
                  msg: 'please enter your phone'),
              TextInputField(
                  icon: Icons.lock,
                  hint: 'Password',
                  controller: password,
                  msg: 'please enter your password'),
              Center(
                child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                              side: const BorderSide(color: Colors.blue)))),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          showLoadingDialog(context);
                        });

                        dynamic res = await CreateUserwithEmailAndPassword(
                            email.text.trim(), password.text);

                        if (res.ch == 0) {
                          setState(() {
                            Navigator.of(context).pop();
                            showBar(context, res.data, 0);
                          });
                        } else {
                          await uploadImageToFirebase(context);
                          int? a = int.tryParse(number.text);
                          auth.User? user = FirebaseAuth.instance.currentUser;
                          await saveAdmin(
                              aid: user!.uid,
                              number: a!,
                              name: name.text,
                              email: email.text,
                              aprrov: 0);
                          setState(() {
                            Navigator.of(context).pop();
                            showBar(
                                context, "User created !! Back to Login", 1);
                          });
                        }
                      }
                    }
                  },
                  child: const Text(
                    'Signup',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Center(
          child: SpinKitFadingCube(
            color: Colors.blue,
            size: 50,
          ),
        ),
      ),
    );
  }

  String? url;
  Future uploadImageToFirebase(BuildContext context) async {
    auth.User? user = FirebaseAuth.instance.currentUser;
    user!.updateDisplayName(name.text.trim());
    await user.reload();
    return user;
  }

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  static final _formKey = GlobalKey<FormState>();
  void imageSelect() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage!.path.isNotEmpty) {
      setState(() {
        _imageFile = File(selectedImage.path);
      });
    }
  }
}
