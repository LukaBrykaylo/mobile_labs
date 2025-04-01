class SignUpValidationService {
  bool validateEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool validationName(String name) {
    final RegExp nameRegex = RegExp(r'^[a-zA-z]{2,}$');
    return nameRegex.hasMatch(name);
  }

  bool validationPassword(String password) {
    final RegExp passwordRegex = RegExp(r'^[a-zA-Z0-9._%+-]{6,}');
    return passwordRegex.hasMatch(password);
  }
}
