import 'package:bank_management/ui/Login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_upi/flutter_upi.dart';
import 'package:provider/provider.dart';
import 'package:bank_management/provider/LoginProvider.dart';

import '../model/user.dart';

void verifyPhoneNumber(String phone, BuildContext context) async {
  final provider = Provider.of<LoginProvider>(context, listen: false);
  var _auth = FirebaseAuth.instance;
  var _verificationId;
  final PhoneVerificationCompleted verificationCompleted =
      (PhoneAuthCredential phoneAuthCredential) {
    //_auth.signInWithCredential(phoneAuthCredential);
    //provider.setIsLoggedIn(true);
  };

  final PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {};

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
  print('VerificationId : $_verificationId');
  await _auth.verifyPhoneNumber(
    phoneNumber: "+91" + phone,
    timeout: const Duration(seconds: 5),
    verificationCompleted: verificationCompleted,
    verificationFailed: verificationFailed,
    codeSent: codeSent,
    codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
  );
}

Future<bool> signInWithPhoneNumber(String otp, String verificationId) async {
  try {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User user = userCredential.user;
    final User currentUser = FirebaseAuth.instance.currentUser;
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

String getUid() {
  return FirebaseAuth.instance.currentUser.uid;
}

Future<bool> isUserPresent() async {
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(getUid()).get();
  return documentSnapshot.exists;
}

void registerUser(MyUser user) {
  FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'name': user.name,
    'phone': user.phoneNumber,
    'email': user.email,
    'uid': user.uid,
    'branches': 1,
    'balance': user.balance,
  });
  createBranch('Master', 'Master Branch');
}

void deleteUser(BuildContext context) async {
  FirebaseFirestore.instance.collection('user').doc(getUid()).delete();
  FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) {
        return Login();
      },
    ),
  );
}

Future<MyUser> getUserDetails() async {
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(getUid()).get();
  DocumentSnapshot doc = await documentSnapshot.reference
      .collection('branches')
      .doc('master')
      .get();
  int addAmount = await getAddAmount();
  MyUser user = MyUser(
    documentSnapshot.data()["name"],
    documentSnapshot.data()['uid'],
    documentSnapshot.data()['phone'],
    documentSnapshot.data()['email'],
    (await getBranches()).length,
    documentSnapshot.data()['balance'],
    addAmount,
  );
  return user;
}

Future<List<DocumentSnapshot>> getBranches() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .collection('branches')
      .get();
  return querySnapshot.docs;
}

Future<int> getBranchBalance(String branch) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .collection('branches')
      .doc(branch)
      .get();
  return documentSnapshot.data()['balance'];
}

Future<int> getAddAmount() async {
  int maxAmount = 0, addAmount = 0;
  List<DocumentSnapshot> documents = await getBranches();
  for (int i = 0; i < documents.length; i++) {
    if (documents[i].id == 'master') {
      maxAmount = documents[i].data()['balance'];
    } else {
      addAmount += documents[i].data()['balance'];
    }
  }
  return maxAmount - addAmount;
}

Future<Map<String, double>> getBalanceMap() async {
  Map<String, double> dataMap = Map();
  getAddAmount().then((value) {
    dataMap.putIfAbsent('others', () => double.parse(value.toString()));
  });
  List<DocumentSnapshot> documentList = await getBranches();
  for (int i = 0; i < documentList.length; i++) {
    if (documentList[i].id != 'master') {
      dataMap.putIfAbsent(
        documentList[i].id,
        () => double.parse(documentList[i].data()['balance'].toString()),
      );
    }
  }
  return dataMap;
}

void createBranch(String name, String description) async {
  FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .collection('branches')
      .doc(name)
      .set({
    'balance': 0,
    'time': DateTime.now().millisecondsSinceEpoch,
    'transactions': 0,
    'desc': description,
  });
  updateBranchCount();
}

void deleteBranch(String name) async {
  FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .collection('branches')
      .doc(name)
      .delete();
  updateBranchCount();
}

void updateBranchCount() async {
  FirebaseFirestore.instance.collection('users').doc(await getUid()).update({
    'branches': (await getBranches()).length,
  });
}

Future<List<QueryDocumentSnapshot>> getTransactionList(
    String branch, int type) async {
  QuerySnapshot querySnapshot = type != 0
      ? await FirebaseFirestore.instance
          .collection('users')
          .doc(getUid())
          .collection('branches')
          .doc(branch)
          .collection('transactions')
          .where('type', isEqualTo: type)
          .orderBy('time', descending: true)
          .get()
      : await FirebaseFirestore.instance
          .collection('users')
          .doc(getUid())
          .collection('branches')
          .doc(branch)
          .collection('transactions')
          .orderBy('time', descending: true)
          .get();
  return querySnapshot.docs;
}

void addMoney(String branch, int amount, String desc) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .collection('branches')
      .doc(branch)
      .get();
  var balance = documentSnapshot.data()['balance'];
  documentSnapshot.reference.update({
    'balance': balance + amount,
  });
  makeTransaction(branch, amount, 1, desc);
}

void debitMoney(String branch, int amount, String desc) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .collection('branches')
      .doc(branch)
      .get();
  var balance = documentSnapshot.data()['balance'];
  documentSnapshot.reference.update({
    'balance': balance - amount,
  });
  makeTransaction(branch, amount, 2, desc);
}

void makeUpiPayment(
    String amount, String phone, String app, String desc, String branch) async {
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
    debitMoney("Master", int.parse(amount), "From branch $branch");
  }
}

void makeTransaction(String branch, int amount, int type, String desc) async {
  int balance = await getBranchBalance(branch);
  FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .collection('branches')
      .doc(branch)
      .collection('transactions')
      .doc(DateTime.now().millisecondsSinceEpoch.toString())
      .set({
    'time': DateTime.now().millisecondsSinceEpoch,
    'amount': amount,
    'type': type,
    'desc': desc,
    'balance': balance,
  });
}
