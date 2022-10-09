import 'package:worknotes/services/auth/auth_services.dart';
import 'package:worknotes/views/notes/new_notes_view.dart';
import 'package:worknotes/views/notes/notes_view.dart';
import 'package:flutter/material.dart';
import 'package:worknotes/constants/routes.dart';
import 'package:worknotes/views/login_view.dart';
import 'package:worknotes/views/register_view.dart';
import 'package:worknotes/views/verify_email_view.dart';
//import 'dart:developer' as devtools show log;

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
        loginRoutes: (context) => const LoginView(),
        registerRoutes: (context) => const RegisterView(),
        notesRoutes: (context) => const NotesView(),
        verifyemail: (context) => const VerifyMyEmail(),
        newNotesRoutes: (context) => const NewNotesView(),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthServices.firebase().initalize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthServices.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyMyEmail();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}


//Scaffodf return karna hai in Homepage
//Logout Page
