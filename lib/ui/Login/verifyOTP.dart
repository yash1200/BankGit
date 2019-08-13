import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/provider/LoginProvider.dart';
import 'package:bank_management/ui/Widgets/CustomPaint.dart';
import 'package:bank_management/ui/Login/loginWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../HomePage.dart';

class VerifyOtp extends StatefulWidget {
  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  var fkey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    var size = MediaQuery.of(context).size;
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
                    title: 'Enter\nOTP',
                    subtitle: 'Verify-OTP',
                    isLoading: isLoading,
                    textField: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter OTP',
                        labelText: 'Enter OTP',
                      ),
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.length != 6) {
                          return 'Invalid OTP';
                        }
                        return null;
                      },
                    ),
                    onTap: () {
                      print(provider.getVerificationId);
                      setState(() {
                        isLoading = true;
                      });
                      signInWithPhoneNumber(
                        otpController.text,
                        provider.getVerificationId,
                        context,
                      ).then((value) {
                        if (value) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }));
                        }
                      });
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
