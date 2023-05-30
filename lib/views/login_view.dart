//import 'dart:html';

//import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'dart:developer' as devtools show log;

import 'package:worknotes/constants/routes.dart';
import 'package:worknotes/services/auth/auth_exception.dart';
import 'package:worknotes/services/auth/bloc/auth_bloc.dart';
import 'package:worknotes/services/auth/bloc/auth_event.dart';
import 'package:worknotes/utilities/dialog/error_dialog.dart';

//import 'package:worknotes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text('Login')),
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
                context.read<AuthBloc>().add(AuthEventLogin(
                      email,
                      password,
                    ));
                // ignore: use_build_context_synchronously
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Wrong Password',
                );
              } on GenericAuthException {
                await showErrorDialog(context, 'Authentication Error');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoutes, (route) => false);
            },
            child: const Text("Don't have a account? Register here!!"),
          )
        ],
      ),
    );
  }
}
