import 'dart:convert';
import 'dart:async';
import 'package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';
import 'package:async/async.dart';
import 'dart:io';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  int expiresIn = 3600 * 24;
  Map<String, String> authHeaders = {
    "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
    "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
    "Content-Type": "application/json"
  };

  Map<String, String> imgHeaders = {
    "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
    "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
    "Content-Type": "image/jpg"
  };

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

  Future<bool> signup(String email, String password, String username) async {
    const url = "https://wwvo3d7k.lc-cn-n1-shared.com/1.1/users";
    try {
      final response = await http.post(url,
          headers: authHeaders,
          body: json.encode(
              {"email": email, "password": password, "username": username}));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData['code']);
        throw HttpException(responseData['code'].toString());
        return false;
      }
      _token = responseData['sessionToken'];
      _userId = responseData['objectId'];
      return true;
    } catch (error) {
      throw error;
    }

    // return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    // return _authenticate(email, password, 'verifyPassword');
    const url = "https://wwvo3d7k.lc-cn-n1-shared.com/1.1/login";
    try {
      final response = await http.post(url,
          headers: authHeaders,
          body: json.encode({"email": email, "password": password}));
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['code'].toString());
      }
      //no error
      //I/flutter ( 2204): {email: hhhhhao@gmail.com, sessionToken: aymdwjz3ikpu0lzdim1i8luvo, updatedAt: 2019-12-16T15:23:32.609Z, objectId: 5df7a1747796d900684723f8, username: evanfungvsnsns, createdAt: 2019-12-16T15:23:32.609Z, emailVerified: false, mobilePhoneVerified: false}
      _token = responseData['sessionToken'];
      _userId = responseData['objectId'];
      _expiryDate = DateTime.now().add(Duration(seconds: expiresIn));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
    // print(response.body);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    //DateTime object now
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> uploadProfilePic(File image, String fileName) async {
    var url = 'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/files/$fileName';
    final response = await http.post(url,
        headers: imgHeaders, body: image.readAsBytesSync());
    print(response.body);
    final responsedData = json.decode(response.body) as Map<String, dynamic>;
    print(responsedData['objectId']);
    //attach this file object to current user.
    url = 'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/users/$_userId';
    final responseInUserReq = await http.put(url,
        headers: {
          "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
          "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
          "Content-Type": "application/json",
          "X-LC-Session": this._token
        },
        body: json.encode({
          'name': fileName,
          'profilePic': {'id': responsedData['objectId'], '__type': 'File'}
        }));
    print(responseInUserReq.body);
  }
}
