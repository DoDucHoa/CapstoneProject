class InputValidator {
  String? isEmpty(String text) {
    if (text.isEmpty) {
      return "Field is empty";
    }
    return null;
  }

  String? isValidMail(String text) {
    var valid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(text);
    return valid != true ? "Invalid email address" : null;
  }
}
