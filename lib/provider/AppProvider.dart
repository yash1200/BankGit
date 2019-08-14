import 'package:bank_management/model/user.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  User _user;

  User get getUser => _user;

  setUser(User value) {
    _user = value;
    notifyListeners();
  }
}
