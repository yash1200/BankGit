import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bank_management/provider/LoginProvider.dart';

void verifyPhoneNumber(String phone, BuildContext context) async {
  final provider = Provider.of<LoginProvider>(context);
  var _auth = FirebaseAuth.instance;
  var _verificationId;
  print(phone);
  final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential phoneAuthCredential) {
    //_auth.signInWithCredential(phoneAuthCredential);
  };

  final PhoneVerificationFailed verificationFailed =
      (AuthException authException) {};

  final PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    _verificationId = verificationId;
    provider.setVerificationId(verificationId);
  };

  final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    print('Failed..');
    _verificationId = verificationId;
  };

  print('Sending..');
  await _auth.verifyPhoneNumber(
      phoneNumber: "+91" + phone,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
}

Future<bool> signInWithPhoneNumber(
    String otp, String verificationId, BuildContext context) async {
  print('Otp is: $otp');
  print('Verification id $verificationId');
  final AuthCredential credential = PhoneAuthProvider.getCredential(
    verificationId: verificationId,
    smsCode: otp,
  );
  print('reached');
  AuthResult authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
  var user = authResult.user;
  print('user is ${user.uid}');
  final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
  assert(user.uid == currentUser.uid);
  if (user != null) {
    return true;
  } else {
    return false;
  }
}
