import 'dart:convert';
import 'dart:async'; // to use timer with outo-logout

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_linux/shared_preferences_linux.dart';

import '../models/http_exception.dart';

class Auth extends ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _autoTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authentication(
      String email, String password, String partOfUrl) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$partOfUrl?key=AIzaSyCJlmfhoEEFCJZ4pWTiVEOwnlXw3DCzZQk";
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        // if error exist in body even it's return 200, then some error occured
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      // set it here to start the timer in case the token is expire the app automaticlly logout
      autoLogout();
      notifyListeners();

      // here after we authenticate we will save values in device to get it when we reporn the application
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();

    return true;
  }

  Future<void> signup(String email, String password) async {
    return _authentication(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authentication(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    // cancel the current timer not needed any more
    if (_autoTimer != null) {
      _autoTimer.cancel();
      _autoTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs
        .clear(); // just web all the data inside the shared , because it my cause to re-login when we try to signout
    //prefs.remove('userData'); // incase we want to remove specific key
  }

  void autoLogout() {
    // cancle the timer if exist to strat new one
    if (_autoTimer != null) {
      _autoTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _autoTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
