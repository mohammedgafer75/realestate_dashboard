import 'package:flutter/material.dart';
import 'package:rs_admin/home.dart';
import 'package:rs_admin/http.dart';
import 'package:rs_admin/sign_up.dart';
import 'package:rs_admin/text_field_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextInputField(
                icon: Icons.email,
                hint: 'Email',
                controller: email,
                msg: 'please enter your email'),
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
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const HomePage()));
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      showLoadingDialog(context);
                    });

                    dynamic res = await signInwithEmailAndPassword2(
                        email.text.trim(), password.text);
                    if (res.ch == 0) {
                      setState(() {
                        Navigator.of(context).pop();
                        showBar(context, res.data, 0);

                        //print('this is result:$res');
                      });
                    } else {
                      var ch = await FirebaseFirestore.instance
                          .collection('Admin')
                          .where('email', isEqualTo: email.text)
                          .where('aprrov', isEqualTo: 1)
                          .get();
                      if (ch.docs.isEmpty) {
                        Navigator.of(context).pop();
                        showBar(context, 'you dont have a permission', 0);
                      } else {
                        setState(() {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const HomePage()),
                              (Route<dynamic> route) => false);
                        });
                      }
                    }
                  }
                },
                child: const Text(
                  'SignIn',
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      builder: (context) => const AlertDialog(
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

  Future go(dynamic res) async {
    // SharedPreferences sharedpreference = await SharedPreferences.getInstance();
    // sharedpreference.setString("u_id", res.data.uid);
    // sharedpreference.setString("login", "ok");
    // sharedpreference.setString("url", res.data.photoURL);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
        (Route<dynamic> route) => false);
  }
}
