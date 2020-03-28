import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';
import '../model/tama.dart';
import '../service/tama-service.dart';

const String USER_INFO = 'userInfo';
const String TAMA = 'tama';
const String DATA_FILE = 'dataUser.json';
const String PASSWORD = 'Password';
const String EMAIL = 'Email';
const String EMAIL_REGEX =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
final LocalStorage _localStorage = LocalStorage(DATA_FILE);

class LoadingStateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Loaind')),
    );
  }
}

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
  final Map<String, dynamic> values = getUserInfo();
  return values != null && values.isNotEmpty;
}

Future<void> saveUser(Map<String, dynamic> info) async {
  _localStorage.setItem(USER_INFO, info);
}

Future<void> saveTama(Map<String, dynamic> info) async {
  _localStorage.setItem(TAMA, info);
}

Map<String, dynamic> getTama() {
  final Map<String, dynamic> values = _localStorage.getItem(TAMA) as Map<String, dynamic>;
  return values;
}

Map<String, dynamic> getUserInfo() {
  final Map<String, dynamic> values = _localStorage.getItem(USER_INFO) as Map<String, dynamic>;
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
  final LoadingScreen screen = LoadingScreen();
  Navigator.of(context).push<LoadingScreen>
    (MaterialPageRoute<LoadingScreen>(builder: (BuildContext context) => screen));
}

void removeLoading<T>(BuildContext context, T obj) {
  Navigator.of(context).pop(obj);
}

class TamaUtil {

  static String _append(String s, String s2) {
    return s + s2;
  }

  static List<String> getImages(TamaType tamaType) {
    final String name = describeEnum(tamaType).toLowerCase();
    final String camel = _camelCase(describeEnum(tamaType));
    return List<String>.of(<String>[
      _append('assets/animals/$name/$camel','_Down.png'),
      _append('assets/animals/$name/$camel','_Left.png'),
      _append('assets/animals/$name/$camel','_Right.png'),
      _append('assets/animals/$name/$camel','_Up.png')
    ]);
  }

  static String _camelCase(String s) {
    final String sLow = s.toLowerCase();
    return sLow[0].toUpperCase() + sLow.substring(1);
  }

  static String getDeadImage(TamaType tamaType) {
    final String name = describeEnum(tamaType).toLowerCase();
    final String camel = _camelCase(describeEnum(tamaType));
    return _append('assets/animals/$name/$camel','_Dead.png');
  }

  static String getAvatar(TamaType tamaType) {
    final String name = describeEnum(tamaType).toLowerCase();
    final String camel = _camelCase(describeEnum(tamaType));
    return _append('assets/animals/$name/$camel','_Avatar_Circle.png');
  }

  static String getEggImage(TamaType tamaType) {
    switch (tamaType) {
      case TamaType.CAT:
        return 'assets/eggs/egg_blue';
      case TamaType.CHICK:
        return 'assets/eggs/egg_yellow';
      case TamaType.PIG:
      case TamaType.RABBIT:
        return 'assets/eggs/egg_pink';
      case TamaType.FOX:
      case TamaType.MOUSE:
        return 'assets/eggs/egg_red';
    }
    return ''; //Never Happen
  }

  static Map<EmotionType, String> getEmotions() {
    final Map<EmotionType,String> vals = <EmotionType,String>{};
    for (final EmotionType em in EmotionType.values) {
      final String camel = _camelCase(describeEnum(em));
      vals[em] = 'assets/emotions/Status_$camel.png';
    }
    return vals;
  }

  static int getImagesSize() {
    return 4;
  }
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