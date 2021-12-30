import 'package:flutter/material.dart';
import 'package:rs_admin/admin_req.dart';
import 'package:rs_admin/all_realestate.dart';
import 'package:rs_admin/change_password.dart';
import 'package:rs_admin/realestate_req.dart';
import 'package:rs_admin/sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => const SignIn()),
                    (Route<dynamic> route) => false);
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: height / 5,
        ),
        padding: EdgeInsets.only(
            top: height / 40, left: width / 8, right: width / 8),
        child: Center(
          child: GridView.count(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: .90,
              children: const [
                Card_d(
                  icon:
                      Icon(Icons.home_outlined, size: 30, color: Colors.white),
                  title: 'All Realestate',
                  nav: ALLRealEstate(),
                ),
                Card_d(
                  icon:
                      Icon(Icons.home_outlined, size: 30, color: Colors.white),
                  title: 'RealEstate Requset',
                  nav: RealEstateReq(),
                ),
                Card_d(
                  icon:
                      Icon(Icons.accessibility, size: 30, color: Colors.white),
                  title: 'Admin Requset',
                  nav: AdminReq(),
                ),
                Card_d(
                  icon: Icon(Icons.change_circle_outlined,
                      size: 30, color: Colors.white),
                  title: 'Change Password',
                  nav: ChangePassword(),
                ),
              ]),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class Card_d extends StatefulWidget {
  const Card_d(
      {Key? key, required this.title, required this.icon, required this.nav})
      : super(key: key);
  final String title;
  final dynamic icon;
  final dynamic nav;

  @override
  State<Card_d> createState() => _Card_dState();
}

// ignore: camel_case_types
class _Card_dState extends State<Card_d> {
  void showBar(BuildContext context, String msg) {
    var bar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget.nav));
      },
      child: Card(
        color: const Color.fromRGBO(19, 26, 44, 1.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(child: widget.icon),
              const SizedBox(
                height: 10,
              ),
              Text(widget.title, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
