//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:worknotes/constants/routes.dart';
import 'package:worknotes/services/auth/auth_services.dart';

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
              "We've sent you an email verification. Please open it to verify your account"),
          const Text(
              "if you haven't recieved a verification email yet, press the button below"),
          TextButton(
            onPressed: () async {
              await AuthServices.firebase().sendEmailVerification();
            },
            child: const Text("Send Email Verification"),
          ),
          TextButton(
            onPressed: () async {
              await AuthServices.firebase().logOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoutes, (route) => false);
            },
            child: const Text("restart "),
          )
        ],
      ),
    );
  }
}
