import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyMyEmail extends StatefulWidget {
  const VerifyMyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyMyEmail> createState() => _VerifyMyEmailState();
}

class _VerifyMyEmailState extends State<VerifyMyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMaail Verifiacction')),
      body: Column(
        children: [
          const Text('Please Verify Your Email Address:'),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text("Send Email Verification"),
          )
        ],
      ),
    );
  }
}
