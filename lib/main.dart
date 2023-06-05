import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worknotes/helpers/loading/loading_screen.dart';
import 'package:worknotes/services/auth/bloc/auth_bloc.dart';
import 'package:worknotes/services/auth/bloc/auth_event.dart';
import 'package:worknotes/services/auth/bloc/a_state.dart';
import 'package:worknotes/services/auth/firebaase_auth_provider.dart';
import 'package:worknotes/views/notes/create_update_notes_view.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const Homepage(),
      ),
      routes: {
        createOrUpdateNotesRoutes: (context) => const CreateUpdateNotesView()
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          debugPrint("I am being called?");
          LoadingScreen().show(
              context: context, text: state.isText ?? 'Please wait moment');
        } else {
          debugPrint("I am being called");
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedVerification) {
          return const VerifyMyEmail();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
