import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worknotes/services/auth/bloc/a_state.dart';
import 'package:worknotes/services/auth/bloc/auth_bloc.dart';
import 'package:worknotes/services/auth/bloc/auth_event.dart';
import 'package:worknotes/utilities/dialog/error_dialog.dart';
import 'package:worknotes/utilities/dialog/password_reset_email_sent.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPaasswordResetSendDialog(context);
          }
          if (state.exception != null) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(context, 'We Couldnot Process your request');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Forgot Password')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  'If you Forgot your password please enter your email we will send a paswword reset link to your email'),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: _controller,
                decoration: const InputDecoration(
                    hintText: 'your email address..........'),
              ),
              TextButton(
                  onPressed: () {
                    final email = _controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                  child: const Text('Paswword Reset')),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text('Back to login page'))
            ],
          ),
        ),
      ),
    );
  }
}
