import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _verificationId;

  bool get getIsLoggedIn => _isLoggedIn;

  setIsLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  String get getVerificationId => _verificationId;

  setVerificationId(String value) {
    _verificationId = value;
    notifyListeners();
  }
}
