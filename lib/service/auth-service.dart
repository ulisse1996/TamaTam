import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../common/common.dart';
import '../model/tama.dart';
import '../model/user-info.dart' as model;
import '../pages/tamapage/tamapage.dart';
import '../repository/tama-repository.dart' as tama_repository;
import '../repository/user-tama-repository.dart' as user_repository;

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthService {

  static Future<void> processLogin(BuildContext currentContext, TextEditingController emailController, TextEditingController passwordController) async {
    try {
      final AuthResult result = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );
      model.UserInfo userInfo = await user_repository.findUser(result.user.uid);
      if (userInfo == null) {
        print('User is null');
        userInfo = model.UserInfo(result.user.uid, '', DateTime.now());
        await user_repository.createUser(userInfo);
        await saveLastLogin(userInfo.lastLogin);
      } else {
        print('Found ${userInfo.toString()}');

        // Save LastLogin
        await saveLastLogin(userInfo.lastLogin);
      }
      Tama tama = await tama_repository.findTamaById(userInfo.tamaId);
      if (tama == null) {
        print('Tama is null');
        tama = Tama.empty(Uuid().v4());
        await tama_repository.createTama(tama);
        userInfo.tamaId = tama.tamaId;
        await user_repository.saveUser(userInfo);
      } else {
        print('Found Tama : ${tama.toString()}');
      }

      // Save info and Tama in localstorage
      await saveUser(userInfo.toJson());
      await saveTama(tama.toJson());

      Navigator.push<TamaPage>(
        currentContext,
        MaterialPageRoute<TamaPage>(builder: (BuildContext context) => TamaPage()),
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
        duration: const Duration(seconds: 10),
      )
    );
  }

  
  static String _decodeMessage(PlatformException error) {
    String errorMessage;
    switch (error.code) {
      case 'ERROR_INVALID_EMAIL':
        errorMessage = 'Your email address appears to be malformed.';
        break;
      case 'ERROR_WRONG_PASSWORD':
        errorMessage = 'Your password is wrong.';
        break;
      case 'ERROR_USER_NOT_FOUND':
        errorMessage = "User with this email doesn't exist.";
        break;
      case 'ERROR_USER_DISABLED':
        errorMessage = 'User with this email has been disabled.';
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        errorMessage = 'Too many requests. Try again later.';
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        errorMessage = 'Signing in with Email and Password is not enabled.';
        break;
      default:
        errorMessage = 'An undefined Error happened.';
    }
    return errorMessage;
  }

  static Future<void> processRegister(BuildContext currentContext, TextEditingController emailController, TextEditingController passwordController) async {
    try {
      final AuthResult auth = await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      final model.UserInfo userInfo = model.UserInfo(auth.user.uid, '', DateTime.now());
      saveUser(userInfo.toJson());
      Navigator.push<TamaPage>(
        currentContext,
        MaterialPageRoute<TamaPage>(builder: (BuildContext context) => TamaPage()),
      );
    } catch(error) {
      print(error);
      _toggleError(currentContext, error);
    }
  }
}

Future<void> updateUser(model.UserInfo userInfo) async {
  await user_repository.saveUser(userInfo);
}