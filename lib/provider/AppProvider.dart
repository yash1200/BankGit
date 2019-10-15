import 'package:bank_management/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_upi/flutter_upi.dart';

class AppProvider with ChangeNotifier {
  User _user;
  int _transactionIndex = 0;
  var _upiType;
  int _paymentMode = 0;
  String _transactionFrom = 'Not Selected',
      _transactionTo = 'Not Selected';
  int _transactionFromIndex = 0,
      _transactionToIndex = 0,
      _transactionFromBalance = 0;

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

  get transactionTo => _transactionTo;

  setTransactionTo(value) {
    _transactionTo = value;
    notifyListeners();
  }

  String get transactionFrom => _transactionFrom;

  setTransactionFrom(String value) {
    _transactionFrom = value;
    notifyListeners();
  }

  get transactionToIndex => _transactionToIndex;

  setTransactionToIndex(value) {
    _transactionToIndex = value;
    notifyListeners();
  }

  int get transactionFromIndex => _transactionFromIndex;

  setTransactionFromIndex(int value) {
    _transactionFromIndex = value;
    notifyListeners();
  }

  get transactionFromBalance => _transactionFromBalance;

  setTransactionFromBalance(value) {
    _transactionFromBalance = value;
    notifyListeners();
  }

  int get paymentMode => _paymentMode;

  setPaymentMode(int value) {
    _paymentMode = value;
    notifyListeners();
  }
}
