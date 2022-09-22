//import 'dart:html';

// ignore_for_file: use_build_context_synchronously

//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:worknotes/firebase_options.dart';

import 'package:worknotes/constants/routes.dart';
import 'package:worknotes/services/auth/auth_exception.dart';
import 'package:worknotes/services/auth/auth_services.dart';
import 'package:worknotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register view'),
      ),
      body: Column(
        children: [
          TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter your email')),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthServices.firebase().createUser(
                  email: email,
                  password: password,
                );
                AuthServices.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyemail);
              } on WeakPasswordAuthException {
                await showErrorDialog(context, 'Weak pasword');
              } on EmailAlreadyInAuthUseException {
                await showErrorDialog(context, 'email already in use');
              } on InvalidEmailAuthException {
                await showErrorDialog(context, 'invalid email entered');
              } on GenericAuthException {
                await showErrorDialog(context, 'Authentication Error');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoutes, (route) => false);
            },
            child: const Text('Already Registered? Login here'),
          )
        ],
      ),
    );
  }
}
