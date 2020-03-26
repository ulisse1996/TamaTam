import 'package:flutter/material.dart';
import 'common/common.dart';
import 'pages/homepage/homepage.dart';
import 'pages/tamapage/tamapage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange
      ),
      home: checkLogin(),
    );
  }

  Widget checkLogin() => checkLogged() ? TamaPage() : HomePage();
}

