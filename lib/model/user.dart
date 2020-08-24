class MyUser {
  String _name;
  String _uid;
  String _phoneNumber;
  String _email;
  int _branches;
  double _balance;
  int _addAmount;

  MyUser(this._name, this._uid, this._phoneNumber, this._email, this._branches,
      this._balance, this._addAmount);

  String get email => _email;

  setEmail(String value) {
    _email = value;
  }

  String get phoneNumber => _phoneNumber;

  setPhoneNumber(String value) {
    _phoneNumber = value;
  }

  String get uid => _uid;

  setUid(String value) {
    _uid = value;
  }

  String get name => _name;

  setName(String value) {
    _name = value;
  }

  double get balance => _balance;

  setBalance(double value) {
    _balance = value;
  }

  int get addAmount => _addAmount;

  setAddAmount(int value) {
    _addAmount = value;
  }

  int get branches => _branches;

  setBranches(int value) {
    _branches = value;
  }
}
