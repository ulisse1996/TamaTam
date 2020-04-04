import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';

const String USER_INFO = 'userInfo';
const String TAMA = 'tama';
const String DATA_FILE = 'dataUser.json';
const String PASSWORD = 'Password';
const String EMAIL = 'Email';
const String EMAIL_REGEX =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
final LocalStorage _localStorage = LocalStorage(DATA_FILE);

// Base page of all pages in the app
abstract class BasePageWidget extends StatelessWidget {
  final Padding _title = const Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text('TamaTama',
          style:  TextStyle(fontFamily: 'Mango Drink', fontSize: 60)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: body(),
    );
  }

  Widget body();

  PreferredSizeWidget appBar(BuildContext context) {
    if (checkLogged()) {
      // User Info
      return AppBar(
          title: _title,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Transform.rotate(angle:  90 * math.pi / 90,
            child: IconButton(
              iconSize: 25,
              icon: Icon(Icons.exit_to_app, color: Colors.black),
              onPressed: () async {
                await _localStorage.deleteItem(USER_INFO);
                Navigator.push<MyApp>(
                  context,
                  MaterialPageRoute<MyApp>(builder: (BuildContext context) => MyApp()),
                );
              },
            ),
          ));
    } else {
      // Guest
      return AppBar(
          title: _title,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0);
    }
  }
}

// Validate password field in HomePage widget
String passwordValidator(String value, String title) {
  if (value == null || value.isEmpty) {
    return "$title can't be empty!";
  }

  return null;
}

// Validate email field in Homepage widget
String emailValidator(String value, String title) {
  if (value == null || value.isEmpty) {
    return "$title can't be empty!";
  }
  if (!RegExp(EMAIL_REGEX).hasMatch(value)) {
    return '$title is not valid!';
  }

  return null;
}

// Check if current user is logged
bool checkLogged() {
  final Map<String, dynamic> values = getUserInfo();
  return values != null && values.isNotEmpty;
}

// Save user info in a local storage as a json
Future<void> saveUser(Map<String, dynamic> info) async {
  _localStorage.setItem(USER_INFO, info);
}

// Save tama info in a local storage as a json
Future<void> saveTama(Map<String, dynamic> info) async {
  _localStorage.setItem(TAMA, info);
}

// Get current Tama
Map<String, dynamic> getTama() {
  final Map<String, dynamic> values = _localStorage.getItem(TAMA) as Map<String, dynamic>;
  return values;
}

// Get current user info
Map<String, dynamic> getUserInfo() {
  final Map<String, dynamic> values = _localStorage.getItem(USER_INFO) as Map<String, dynamic>;
  return values;
}

// Util Loading Widget for display a loading screen
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: SpinKitCircle(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}

// Push a new LoadingScreen in current Navigator
void showLoading(BuildContext context) {
  final LoadingScreen screen = LoadingScreen();
  Navigator.of(context).push<LoadingScreen>
    (MaterialPageRoute<LoadingScreen>(builder: (BuildContext context) => screen));
}

// Remove pushed Loading Screen
void removeLoading<T>(BuildContext context, T obj) {
  Navigator.of(context).pop(obj);
}

String decimalSerializer(Decimal dec) {
  return dec.toString();
}

Decimal decimalDeserializer(dynamic dec) {
  if (dec.runtimeType == String) {
    return Decimal.parse(dec as String);
  }
  throw ArgumentError('Type not valid for conversion !');
}

abstract class BaseModel {

  Map<String, dynamic> toJson();

  @override
  String toString() {
    return toJson().toString();
  }
}

Duration differenceFromNow(DateTime date) {
  return DateTime.now().difference(date);
}