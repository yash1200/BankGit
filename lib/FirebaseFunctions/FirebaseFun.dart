import 'package:bank_management/ui/Login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_upi/flutter_upi.dart';
import 'package:provider/provider.dart';
import 'package:bank_management/provider/LoginProvider.dart';

import '../model/user.dart';

import 'package:flutter/foundation.dart';

late ConfirmationResult confirmationResult;

Future<void> verifyNumber(String phone, BuildContext context) async {
  if (!kIsWeb) {
    return await verifyPhoneNumber(phone, context);
  } else {
    return await verifyPhoneNumberForWeb(phone);
  }
}

/// For Android and iOS Users.
Future<void> verifyPhoneNumber(String phone, BuildContext context) async {
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

/// For web users.
Future<void> verifyPhoneNumberForWeb(String phone) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  confirmationResult = await auth.signInWithPhoneNumber(
    "+91" + phone,
  );
}

Future<bool> signIn(String otp, String verificationId) async {
  if (!kIsWeb) {
    return await signInWithPhoneNumber(otp, verificationId);
  } else {
    return await signInWithPhoneNumberForWeb(otp);
  }
}

/// For Android and iOS users.
Future<bool> signInWithPhoneNumber(String otp, String verificationId) async {
  try {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;
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

/// For web users.
Future<bool> signInWithPhoneNumberForWeb(String otp) async {
  UserCredential userCredential = await confirmationResult.confirm(otp);
  final User? user = userCredential.user;
  if (user != null) {
    return true;
  } else {
    return false;
  }
}

/// Gets the firebase uid.
String getUid() {
  return FirebaseAuth.instance.currentUser.uid;
}

/// Checks if the user is present in database.
Future<bool> isUserPresent() async {
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(getUid()).get();
  return documentSnapshot.exists;
}

/// Adds the user in database.
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

/// Deletes the user from database.
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

/// Fetches user details from database.
Future<MyUser> getUserDetails() async {
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(getUid()).get();
  int addAmount = await getAddAmount();
  MyUser user = MyUser(
    documentSnapshot.data()["name"],
    documentSnapshot.data()['uid'],
    documentSnapshot.data()['phone'],
    documentSnapshot.data()['email'],
    (await getBranches()).length,
    double.parse(documentSnapshot.data()['balance'].toString()),
    addAmount,
  );
  return user;
}

/// Fetches the user branches from database.
Future<List<DocumentSnapshot>> getBranches() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .collection('branches')
      .get();
  return querySnapshot.docs;
}

/// Fetches the balance from a branch.
Future<int> getBranchBalance(String branch) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .collection('branches')
      .doc(branch)
      .get();
  return documentSnapshot.data()['balance'];
}

/// Fetches the amount that can be added in branch.
Future<int> getAddAmount() async {
  int maxAmount = 0, addAmount = 0;
  List<DocumentSnapshot> documents = await getBranches();
  for (int i = 0; i < documents.length; i++) {
    if (documents[i].id == 'Master') {
      maxAmount = documents[i].data()['balance'];
    } else {
      addAmount += documents[i].data()['balance'] as int;
    }
  }
  return maxAmount - addAmount;
}

/// Fetches the balance of all branches for chart.
Future<Map<String, double>> getBalanceMap() async {
  Map<String, double> dataMap = Map();
  getAddAmount().then((value) {
    dataMap.putIfAbsent('others', () => double.parse(value.toString()));
  });
  List<DocumentSnapshot> documentList = await getBranches();
  for (int i = 0; i < documentList.length; i++) {
    if (documentList[i].id != 'Master') {
      dataMap.putIfAbsent(
        documentList[i].id,
        () => double.parse(documentList[i].data()['balance'].toString()),
      );
    }
  }
  return dataMap;
}

/// Function to create a branch.
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

/// Function to delete a branch.
void deleteBranch(String name) async {
  FirebaseFirestore.instance
      .collection('users')
      .doc(getUid())
      .collection('branches')
      .doc(name)
      .delete();
  updateBranchCount();
}

/// Updates branch count in database.
void updateBranchCount() async {
  FirebaseFirestore.instance.collection('users').doc(getUid()).update({
    'branches': (await getBranches()).length,
  });
}

/// Updates balance of user in database.
void updateBalanceInUser(String amount) async {
  FirebaseFirestore.instance
      .collection("users")
      .doc(getUid())
      .get()
      .then((value) {
    FirebaseFirestore.instance.collection("users").doc(getUid()).update({
      "balance": double.parse(value.data()["balance"]) + double.parse(amount),
    });
  });
}

/// Fetches transactions in database.
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

/// Function to add money to database.
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

/// Function to debit money from database.
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

/// Function to make UPI payment.
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
    updateBalanceInUser("-$amount");
  }
}

/// Make a transaction in database.
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
