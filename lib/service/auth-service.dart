import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../common/common.dart';
import '../repository/tama-repository.dart';
import '../homepage/homepage.dart';
import '../model/user-info.dart' as model;

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthService {

  static void processLogin(BuildContext currentContext, TextEditingController emailController, TextEditingController passwordController) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );
      model.UserInfo userInfo = await TamaRepository.findUser(result.user.uid);
      if (userInfo == null) {
        print("User is null");
        userInfo = model.UserInfo(result.user.uid, "");
        TamaRepository.saveUser(userInfo);
      } else {
        print("Found $userInfo");
      }
      saveUser(userInfo.toJson());
      Navigator.push(
        currentContext,
        MaterialPageRoute(builder: (context) => HomePage(true)),
      );
    } catch (error) {
      print(error);
      _toggleError(currentContext, error);
    }
  }

  static void _toggleError(BuildContext context, PlatformException error) {
    String message = _decodeMessage(error);
    Text text = Text(message, style: TextStyle(color: Colors.red));
    // need to build
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: text,
        duration: Duration(seconds: 10),
      )
    );
  }

  
  static String _decodeMessage(PlatformException error) {
    String errorMessage;
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }
    return errorMessage;
  }

  static void processRegister(BuildContext currentContext, TextEditingController emailController, TextEditingController passwordController) async {
    try {
      AuthResult auth = await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      model.UserInfo userInfo = model.UserInfo(auth.user.uid, "");
      saveUser(userInfo.toJson());
      Navigator.push(
        currentContext,
        MaterialPageRoute(builder: (context) => HomePage(true)),
      );
    } catch(error) {
      print(error);
      _toggleError(currentContext, error);
    }
  }
}