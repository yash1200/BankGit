import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  String path;

  CustomImage(this.path);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Image.asset(
      path,
      height: size.height / 8,
      width: size.height / 8,
    );
  }
}
