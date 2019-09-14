import 'package:bank_management/utils/Style.dart';
import 'package:flutter/material.dart';

class transfer extends StatefulWidget {
  @override
  _transferState createState() => _transferState();
}

class _transferState extends State<transfer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: darkColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Transfer',
          style: TextStyle(
            color: darkColor,
          ),
        ),
      ),
      body: Container(),
    );
  }
}
