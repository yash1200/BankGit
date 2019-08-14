class User {
  String _name;
  String _uid;
  String _phoneNumber;
  String _email;

  User(this._name, this._uid, this._phoneNumber, this._email);

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
}
