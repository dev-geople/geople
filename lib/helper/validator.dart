class Validator {
  static const EMAIL_PATTERN = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const USERNAME_PATTERN = r'^/w$';

  bool validateEmail(String email){
    RegExp regex = new RegExp(EMAIL_PATTERN);
    return regex.hasMatch(email);
  }

  bool validateUsername(String username) {
    RegExp regex = new RegExp(USERNAME_PATTERN);
    return regex.hasMatch(username) && username.length >= 5;
  }

  bool validatePassword(String password) {
    //Todo: REGEX
    return password.length > 7;
  }
}