import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/common.dart';
import '../../service/auth-service.dart';

class HomePage extends BasePageWidget {

  @override
  Widget body() {
      return LoginRegisterForm();
  }
}

class LoginRegisterForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                validator: (String value) => emailValidator(value, EMAIL),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                validator: (String value) => passwordValidator(value, PASSWORD),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      processLogin();
                    }
                  },
                  child: const Text('Login'),
                ),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      processRegister();
                    }
                  },
                  child: const Text('Register'),
                )
              ],
            ),
          ],
        )),
    );
  }

  Future<void> processLogin() async {
    showLoading(_formKey.currentContext);
    AuthService.processLogin(_formKey.currentContext,
      _emailController, _passwordController);
  }

  Future<void> processRegister() async {
    showLoading(_formKey.currentContext);
    AuthService.processRegister(_formKey.currentContext,
      _emailController, _passwordController);
  }
}
