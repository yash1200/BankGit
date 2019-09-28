import 'package:bank_management/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_upi/flutter_upi.dart';
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
    //provider.setIsLoggedIn(true);
  };

  final PhoneVerificationFailed verificationFailed =
      (AuthException authException) {};

  final PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    _verificationId = verificationId;
    print("Verification ID: " + verificationId);
    provider.setVerificationId(verificationId);
  };

  final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    _verificationId = verificationId;
  };

  print('Sending..');
  print('ver:$_verificationId');
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
    return false;
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
  createBranch('master', 'Master Branch');
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

Future<int> getBranchBalance(String branch) async {
  DocumentSnapshot documentSnapshot = await Firestore.instance
      .collection('users')
      .document(await getUid())
      .collection('branches')
      .document(branch)
      .get();
  return documentSnapshot.data['balance'];
}


Future<int> getAddAmount() async {
  int maxAmount = 0,
      addAmount = 0;
  List<DocumentSnapshot> documents = await getBranches();
  for (int i = 0; i < documents.length; i++) {
    if (documents[i].documentID == 'master') {
      maxAmount = documents[i].data['balance'];
    } else {
      addAmount += documents[i].data['balance'];
    }
  }
  return maxAmount - addAmount;
}

void createBranch(String name, String description) async {
  Firestore.instance
      .collection('users')
      .document(await getUid())
      .collection('branches')
      .document(name)
      .setData({
    'balance': 0,
    'time': DateTime
        .now()
        .millisecondsSinceEpoch,
    'transactions': 0,
    'desc': description,
  });
}

Future<List<DocumentSnapshot>> getTransactionList(String branch,
    int type) async {
  QuerySnapshot querySnapshot = type != 0
      ? await Firestore.instance
      .collection('users')
      .document(await getUid())
      .collection('branches')
      .document(branch)
      .collection('transactions')
      .where('type', isEqualTo: type)
      .orderBy('time', descending: true)
      .getDocuments()
      : await Firestore.instance
      .collection('users')
      .document(await getUid())
      .collection('branches')
      .document(branch)
      .collection('transactions')
      .orderBy('time', descending: true)
      .getDocuments();
  return querySnapshot.documents;
}

void addMoney(String branch, int amount, String desc) async {
  DocumentSnapshot documentSnapshot = await Firestore.instance
      .collection('users')
      .document(await getUid())
      .collection('branches')
      .document(branch)
      .get();
  var balance = documentSnapshot.data['balance'];
  documentSnapshot.reference.updateData({
    'balance': balance + amount,
  });
  makeTransaction(branch, amount, 1, desc);
}

void debitMoney(String branch, int amount, String desc) async {
  DocumentSnapshot documentSnapshot = await Firestore.instance
      .collection('users')
      .document(await getUid())
      .collection('branches')
      .document(branch)
      .get();
  var balance = documentSnapshot.data['balance'];
  documentSnapshot.reference.updateData({
    'balance': balance - amount,
  });
  makeTransaction(branch, amount, 2, desc);
}

void makeUpiPayment(String amount, String phone, String app, String desc,
    String branch) async {
  String response = await FlutterUpi.initiateTransaction(
    app: app,
    pa: "$phone@upi",
    pn: "Receiver Name",
    tr: "UniqueTransactionId",
    tn: "$desc",
    am: "$amount",
    cu: "INR",
    url: "https://www.google.com",
  );
  print("response: $response");
  FlutterUpiResponse flutterUpiResponse = FlutterUpiResponse(response);
  print("Status: ${flutterUpiResponse.Status}");
  if (flutterUpiResponse.Status == 'SUCCESS') {
    debitMoney(branch, int.parse(amount), desc);
  }
}

void makeTransaction(String branch, int amount, int type, String desc) async {
  int balance = await getBranchBalance(branch);
  Firestore.instance
      .collection('users')
      .document(await getUid())
      .collection('branches')
      .document(branch)
      .collection('transactions')
      .document(DateTime
      .now()
      .millisecondsSinceEpoch
      .toString())
      .setData({
    'time': DateTime
        .now()
        .millisecondsSinceEpoch,
    'amount': amount,
    'type': type,
    'desc': desc,
    'balance': balance,
  });
}
