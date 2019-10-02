class User {
  String _name;
  String _uid;
  String _phoneNumber;
  String _email;
  int _branches;
  int _balance;
  int _addAmount;

  User(this._name, this._uid, this._phoneNumber, this._email, this._branches,
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

  int get balance => _balance;

  setBalance(int value) {
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
