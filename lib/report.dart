import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:const Text('Reports'),
          backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0) ,),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
      children: const [

           CardW(),

           CardW()
      ],
    ),
        ));
  }
}

class CardW extends StatelessWidget {
  const CardW({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(91, 55, 185, 1.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 150,
        width: 200,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

          const Text(
            'Report by: ali',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 18, left: 18),
            child: Text(
                'this post is show more than one time by another person so you must deleted it', style: TextStyle( fontSize: 14,color: Colors.white)),
          ),
          TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.only(
                      top: 10, bottom: 10, left: 15, right: 15)),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(19, 26, 44, 1.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: const BorderSide(
                              color: Color.fromRGBO(19, 26, 44, 1.0))))),
              onPressed: null,
              child: const Text('Show Post',style: TextStyle(color: Colors.white),))
        ]),
      ),
    );
  }
}
