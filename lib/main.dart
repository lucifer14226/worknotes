import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:worknotes/firebase_options.dart';
import 'package:worknotes/views/login_view.dart';
import 'package:worknotes/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView()
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // final user = FirebaseAuth.instance.currentUser;
            // print(user);
            // if (user?.emailVerified ?? false) {
            // } else {
            //   return const VerifyMyEmail();
            // }
            // return const Text('Done');
            return const LoginView();
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

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
