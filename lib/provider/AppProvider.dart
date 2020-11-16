import 'package:bank_management/model/user.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  MyUser _user;
  int _transactionIndex = 0;
  var _upiType;
  int _paymentMode = 0;
  String _transactionFrom = 'Not Selected',
      _transactionTo = 'Not Selected';
  int _transactionFromIndex = 0,
      _transactionToIndex = 0,
      _transactionFromBalance = 0;

  MyUser get getUser => _user;

  void setUser(MyUser value) {
    _user = value;
    notifyListeners();
  }

  int get transactionIndex => _transactionIndex;

  void setTransactionIndex(int value) {
    _transactionIndex = value;
    notifyListeners();
  }

  get upiType => _upiType;

  void setUpiType(value) {
    _upiType = value;
    notifyListeners();
  }

  get transactionTo => _transactionTo;

  void setTransactionTo(value) {
    _transactionTo = value;
    notifyListeners();
  }

  String get transactionFrom => _transactionFrom;

  void setTransactionFrom(String value) {
    _transactionFrom = value;
    notifyListeners();
  }

  get transactionToIndex => _transactionToIndex;

  void setTransactionToIndex(value) {
    _transactionToIndex = value;
    notifyListeners();
  }

  int get transactionFromIndex => _transactionFromIndex;

  void setTransactionFromIndex(int value) {
    _transactionFromIndex = value;
    notifyListeners();
  }

  get transactionFromBalance => _transactionFromBalance;

  void setTransactionFromBalance(value) {
    _transactionFromBalance = value;
    notifyListeners();
  }

  int get paymentMode => _paymentMode;

  void setPaymentMode(int value) {
    _paymentMode = value;
    notifyListeners();
  }
}
