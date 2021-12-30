import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RealEstate extends StatefulWidget {
  RealEstate({Key? key, required this.data}) : super(key: key);
  dynamic data;
  @override
  _RealEstateState createState() => _RealEstateState();
}

class _RealEstateState extends State<RealEstate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0),
        ),
        body: Container(
          child: CardV(widget.data),
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
        showBar(context, 'Realestate rejected', 1);
      });
    } catch (e) {
      setState(() {
        showBar(context, e.toString(), 0);
      });
    }
  }

  Widget CardV(dynamic data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            SizedBox(
                height: 200,
                child: CarouselSlider(
                  options: CarouselOptions(
                    //aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: data['images']
                      .map<Widget>((item) => Container(
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: item,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            value: downloadProgress.progress)),
                                errorWidget: (context, url, error) =>
                                    (Icon(Icons.error)),
                                width: 1000,
                              ),
                            ),
                          ))
                      .toList(),
                )),
            //  const  Image(image: NetworkImage(''),width: 1000,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('Price: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
                  const Text('Description: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${data['description']}')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('Bosted by: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${data['name']}')
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
                      : data['status'] == 2
                          ? const Text('waiting',
                              style: TextStyle(color: Colors.blue))
                          : const Text('Accepted',
                              style: TextStyle(color: Colors.green))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(
                                top: 10, bottom: 10, left: 15, right: 15)),
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromRGBO(19, 26, 44, 1.0)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    side: const BorderSide(
                                        color:
                                            Color.fromRGBO(19, 26, 44, 1.0))))),
                    onPressed: () {
                      accept(data.id);
                    },
                    child: const Text(
                      'Accept',
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(
                                top: 10, bottom: 10, left: 15, right: 15)),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ))),
                    onPressed: () {
                      reject(data.id);
                    },
                    child: const Text(
                      'Reject',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
