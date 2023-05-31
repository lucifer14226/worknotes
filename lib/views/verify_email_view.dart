//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:worknotes/services/auth/bloc/auth_bloc.dart';
import 'package:worknotes/services/auth/bloc/auth_event.dart';

class VerifyMyEmail extends StatefulWidget {
  const VerifyMyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyMyEmail> createState() => _VerifyMyEmailState();
}

class _VerifyMyEmailState extends State<VerifyMyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please open it to verify your account \n\n"),
          const Text("\n"),
          const Text(
              "\n if you haven't recieved a verification email yet, press the button below \n"),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventSendVerfication());
            },
            child: const Text("Send Email Verification"),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventLogOut());
              // ignore: use_build_context_synchronously
            },
            child: const Text("restart "),
          )
        ],
      ),
    );
  }
}
