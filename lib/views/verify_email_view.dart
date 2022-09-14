//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:worknotes/constants/routes.dart';

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
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text("Send Email Verification"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
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
