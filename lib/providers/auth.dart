import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/helpers/global_config.dart';
import 'package:shop_flutter_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate = DateTime.now();
  String? _userId;

  bool get isAuthenticated => token != null;

  String? get token {
    bool isNotExpired = _expiryDate?.isAfter(DateTime.now()) ?? false;
    if (_token != null && isNotExpired) {
      return _token;
    }
    return null;
  }

  String? get userId => _userId;

  Future<void> _authenticate(uri, email, password) async {
    final requestBodyEncoded = json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    try {
      final response = await http.post(uri, body: requestBodyEncoded);
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['error'] != null) {
        throw HttpException(decodedResponse['error']['message'], statusCode: decodedResponse['error']['code']);
      }
      _token = decodedResponse['idToken'];
      _userId = decodedResponse['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            decodedResponse['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(GlobalConfig.signupUri, email, password);
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(GlobalConfig.signinUri, email, password);
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }
}
