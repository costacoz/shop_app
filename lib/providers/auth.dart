import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_flutter_app/helpers/global_config.dart';
import 'package:shop_flutter_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate = DateTime.now();
  String? _userId;
  Timer? _authTimer;

  bool get isAuthenticated {
    return token != null;
  }

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
      int _parsedExpiry = int.parse(decodedResponse['expiresIn']);
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: _parsedExpiry,
        ),
      );
      _initAutoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final authData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String(),
      });
      prefs.setString('authData', authData);
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

  Future<bool> tryAutoSignin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authData')) {
      return false;
    }
    final authData = json.decode(prefs.getString('authData') as String);
    final expiryDate = DateTime.parse(authData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = authData['token'] as String;
    _userId = authData['userId'] as String;
    _expiryDate = DateTime.parse(authData['expiryDate'] as String);
    notifyListeners();
    _initAutoLogout();
    return true;
  }

  void logout() async {
    _authTimer?.cancel();
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('authData');
  }

  void _initAutoLogout() {
    _authTimer?.cancel();
    int timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds ?? 0;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
