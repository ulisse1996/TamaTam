import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math' as math;

import '../main.dart';

const USER_INFO = "userInfo";
const DATA_FILE = "dataUser.json";
const PASSWORD = "Password";
const EMAIL = "Email";
const EMAIL_REGEX =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
final LocalStorage _localStorage = LocalStorage(DATA_FILE);

class LoadingStateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Loaind")),
    );
  }
}

abstract class BasePageWidget extends StatelessWidget {
  final _title = Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text("TamaTama",
          style: TextStyle(fontFamily: "Mango Drink", fontSize: 60)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: body(),
    );
  }

  Widget body();

  Widget appBar(BuildContext context) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
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

String passwordValidator(String value, String title) {
  if (value == null || value.isEmpty) {
    return "$title can't be empty!";
  }

  return null;
}

String emailValidator(String value, String title) {
  if (value == null || value.isEmpty) {
    return "$title can't be empty!";
  }
  if (!RegExp(EMAIL_REGEX).hasMatch(value)) {
    return '$title is not valid!';
  }

  return null;
}

bool checkLogged() {
  Map<String, dynamic> values = getUserInfo();
  return values != null && values.isNotEmpty;
}

void saveUser(Map<String, dynamic> info) {
  _localStorage.setItem(USER_INFO, info);
}

Map<String, dynamic> getUserInfo() {
  Map<String, dynamic> values = _localStorage.getItem(USER_INFO);
  return values;
}

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

void showLoading(BuildContext context) {
  LoadingScreen screen = LoadingScreen();
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}

void removeLoading<T>(BuildContext context, T obj) {
  Navigator.of(context).pop(obj);
}
