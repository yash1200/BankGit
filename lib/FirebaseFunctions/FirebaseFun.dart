import 'package:bank_management/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:bank_management/provider/LoginProvider.dart';

void verifyPhoneNumber(String phone, BuildContext context) async {
  final provider = Provider.of<LoginProvider>(context);
  var _auth = FirebaseAuth.instance;
  var _verificationId;
  print(phone);
  final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential phoneAuthCredential) {
    _auth.signInWithCredential(phoneAuthCredential);
    provider.setIsLoggedIn(true);
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
  try {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: otp,
    );
    AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(user.uid == currentUser.uid);
    if (user != null) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    print('Failed');
  }
}

Future<String> getUid() async {
  return await FirebaseAuth.instance.currentUser().then((user) {
    return user.uid;
  });
}

Future<bool> isUserPresent() async {
  DocumentSnapshot documentSnapshot = await Firestore.instance
      .collection('users')
      .document(await getUid())
      .get();
  return documentSnapshot.exists;
}

void registerUser(User user) {
  Firestore.instance.collection('users').document(user.uid).setData({
    'name': user.name,
    'phone': user.phoneNumber,
    'email': user.email,
    'uid': user.uid,
    'branches': 1,
  });
  Firestore.instance
      .collection('users')
      .document(user.uid)
      .collection('branches')
      .document('Master')
      .setData({
    'balance': 0,
    'transactions': 0,
    'time': DateTime
        .now()
        .millisecondsSinceEpoch,
  });
}

Future<User> getUserDetails() async {
  DocumentSnapshot documentSnapshot = await Firestore.instance
      .collection('users')
      .document(await getUid())
      .get();
  User user = User(
    documentSnapshot.data['name'],
    documentSnapshot.data['uid'],
    documentSnapshot.data['phone'],
    documentSnapshot.data['email'],
  );
  return user;
}

Future<List<DocumentSnapshot>> getBranches() async {
  QuerySnapshot querySnapshot = await Firestore.instance
      .collection('users')
      .document(await getUid())
      .collection('branches')
      .getDocuments();
  return querySnapshot.documents;
}
