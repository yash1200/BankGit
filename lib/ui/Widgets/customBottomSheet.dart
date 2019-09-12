import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class customBottomSheet extends StatefulWidget {
  @override
  _customBottomSheetState createState() => _customBottomSheetState();
}

class _customBottomSheetState extends State<customBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Icon(FontAwesomeIcons.amazonPay),
      ],
    );
  }
}
