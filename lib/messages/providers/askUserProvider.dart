import 'package:flutter/foundation.dart';

class AskUserProvider extends ChangeNotifier {
  String _errorMessage = '';
  String _username = '';

  String get errorMessage => _errorMessage;
  String get username => _username;

  setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  setUsername(String username) {
    _username = username;
    notifyListeners();
  }
}
