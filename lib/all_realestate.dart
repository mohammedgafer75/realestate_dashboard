import 'package:flutter/material.dart';
import 'package:rs_admin/realestate_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ALLRealEstate extends StatefulWidget {
  const ALLRealEstate({Key? key}) : super(key: key);

  @override
  _RealEstateReqState createState() => _RealEstateReqState();
}

class _RealEstateReqState extends State<ALLRealEstate> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('realestate')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No A vailable requset',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    );
                  } else {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return RealEstateV(context, snapshot.data!.docs[index]);
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
                  }
                }
              }),
        ));
  }

  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  Future accept(String id) async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('realestate')
          .doc(id)
          .update({
        "status": 1,
      });
      setState(() {
        showBar(context, 'Realestate Accepted', 1);
      });
    } catch (e) {
      setState(() {
        showBar(context, e.toString(), 0);
      });
    }
  }

  Future reject(String id) async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('realestate')
          .doc(id)
          .update({
        "status": 0,
      });
      setState(() {
        Navigator.of(context).pop();
        showBar(context, 'Realestate rejected', 1);
      });
    } catch (e) {
      setState(() {
        Navigator.of(context).pop();
        showBar(context, e.toString(), 0);
      });
    }
  }

  Widget RealEstateV(BuildContext context, dynamic data) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            width: 200,
            child: CachedNetworkImage(
              imageUrl: data['images'][0],
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2, value: downloadProgress.progress)),
              errorWidget: (context, url, error) => (Icon(Icons.error)),
              width: 1000,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(
                        'Price: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${data['price']} SDG')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('Location: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${data['location']}')
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('Status: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      data['status'] == 0
                          ? const Text('rejected',
                              style: TextStyle(color: Colors.red))
                          : const Text('Accepted',
                              style: TextStyle(color: Colors.green))
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RealEstate(
                                    data: data,
                                  )));
                    },
                    child: const Text('View')),
              ],
            ),
          )
        ],
      ),
    );
  }
}



// ignore: non_constant_identifier_names

