import 'package:bank_management/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_upi/flutter_upi.dart';

class AppProvider with ChangeNotifier {
  User _user;
  int _transactionIndex = 0;
  var _upiType;

  User get getUser => _user;

  setUser(User value) {
    _user = value;
    notifyListeners();
  }

  int get transactionIndex => _transactionIndex;

  setTransactionIndex(int value) {
    _transactionIndex = value;
    notifyListeners();
  }

  get upiType => _upiType;

  setUpiType(value) {
    _upiType = value;
    notifyListeners();
  }
}
