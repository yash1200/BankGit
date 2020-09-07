import 'dart:io';

import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/ui/Login/verifyOTP.dart';
import 'package:bank_management/ui/Widgets/CustomPaint.dart';
import 'package:bank_management/ui/Login/loginWidget.dart';
import 'package:flutter/material.dart';

import '../../FirebaseFunctions/FirebaseFun.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var fkey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: fkey,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Custompaint(),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: LoginWidget(
                    title: 'Login',
                    subtitle: 'Sign-In',
                    isLoading: isLoading,
                    textField: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '98XXXXXXXX',
                      ),
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.length != 10) {
                          return 'Invalid Number';
                        }
                        return null;
                      },
                    ),
                    onTap: () {
                      if (fkey.currentState.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        verifyNumber(phoneNumberController.text, context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return VerifyOtp(phoneNumberController.text);
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
