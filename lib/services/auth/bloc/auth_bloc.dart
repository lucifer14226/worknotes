import 'package:bloc/bloc.dart';
import 'package:worknotes/services/auth/auth_provider.dart';
import 'package:worknotes/services/auth/bloc/auth_event.dart';

import 'a_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    //Initalize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initalize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    //login
    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(email: email, password: password);
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLogInFailure(e));
      }
    });

    //logout
    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(const AuthStateLoading());
        await provider.logOut();
        emit(const AuthStateLoggedOut());
      } on Exception catch (e) {
        emit(AuthStateLogOutFailure(e));
      }
    });
  }
}
