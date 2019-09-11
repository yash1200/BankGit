import 'package:bank_management/utils/Style.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  Widget textField;
  String title;
  String subtitle;
  VoidCallback onTap;
  bool isLoading = false;

  LoginWidget({
    this.textField,
    this.title,
    this.subtitle,
    this.onTap,
    this.isLoading,
  });

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: size.width / 8,
            top: size.height * 0.24,
          ),
          height: size.height / 2,
          width: size.width,
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.06,
        ),
        widget.textField,
        SizedBox(
          height: size.height * 0.06,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              widget.subtitle,
              style: TextStyle(
                color: darkColor,
                fontSize: 25,
              ),
            ),
            GestureDetector(
              onTap: widget.onTap,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: darkColor,
                  shape: BoxShape.circle,
                ),
                child: widget.isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 35,
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
