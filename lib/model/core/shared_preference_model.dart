class SharedPreferenceModel {
  late String _userId, _userName, _userEmail, _userAccount;

  SharedPreferenceModel() {
    _userId = "userId";
    _userName = "userName";
    _userEmail = "userEmail";
    _userAccount = "_userAccount";
  }

  get userAccount => _userAccount;
  get userEmail => _userEmail;
  get userName => _userName;

  String get userId => _userId;
}
