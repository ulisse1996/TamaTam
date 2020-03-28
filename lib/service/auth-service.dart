import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:uuid/uuid.dart';

import '../common/common.dart';
import '../repository/tama-repository.dart';
import '../repository/user-tama-repository.dart';
import '../pages/tamapage/tamapage.dart';
import '../model/user-info.dart' as model;
import '../model/tama.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthService {

  static void processLogin(BuildContext currentContext, TextEditingController emailController, TextEditingController passwordController) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );
      model.UserInfo userInfo = await UserTamaRepository.findUser(result.user.uid);
      if (userInfo == null) {
        print("User is null");
        userInfo = model.UserInfo(result.user.uid, "");
        UserTamaRepository.createUser(userInfo);
      } else {
        print('Found $userInfo');
      }
      Tama tama = await TamaRepository.findTamaById(userInfo.tamaId);
      if (tama == null) {
        tama = Tama.empty(Uuid().v4());
        await TamaRepository.createTama(tama);
        userInfo.tamaId = tama.tamaId;
        await UserTamaRepository.saveUser(userInfo);
      } else {
        print('Found Tama : $tama');
      }
      saveUser(userInfo.toJson());
      saveTama(tama.toJson());
      Navigator.push<TamaPage>(
        currentContext,
        MaterialPageRoute<TamaPage>(builder: (context) => TamaPage()),
      );
    } catch (error) {
      print(error);
      _toggleError(currentContext, error);
    }
  }

  static void _toggleError(BuildContext context, dynamic error) {
    final String message = error.runtimeType == PlatformException ? 
      _decodeMessage(error as PlatformException) : 'Errore Inaspettato';
    final Text text = Text(message, style: TextStyle(color: Colors.red));
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
      Navigator.push<TamaPage>(
        currentContext,
        MaterialPageRoute<TamaPage>(builder: (context) => TamaPage()),
      );
    } catch(error) {
      print(error);
      _toggleError(currentContext, error);
    }
  }
}