import 'package:bank_management/ui/Login/Login.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogOutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          shape: roundedRectangleBorder,
          child: Text(
            "Cancel",
            style: TextStyle(
              color: darkColor,
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Login();
                },
              ),
            );
          },
          shape: roundedRectangleBorder,
          child: Text(
            "Logout",
            style: TextStyle(
              color: darkColor,
            ),
          ),
        ),
      ],
      title: Text("Are you sure?"),
      content: Text("Are you sure you want to logout?"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
