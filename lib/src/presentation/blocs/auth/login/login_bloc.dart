import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/sign_up.dart';
import 'package:equatable/equatable.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/sign_in.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/sign_in_with_google.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this._signIn,
    required this._signUp,
    required this._signInWithGoogle,
  }) : super(LoginInitial()) {
    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
    on<SignInWithGoogleEvent>(_signInWithGoogleHandler);
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final SignInWithGoogle _signInWithGoogle;

  Future<void> _signUpHandler(
      SignUpEvent event, Emitter<LoginState> emit) async {
    emit(const LoggingIn());

    final response = await _signUp(SignUpParams(
      fullName: event.fullName,
      phoneArea: event.phoneArea,
      phoneNumber: event.phoneNumber,
      email: event.email,
      password: event.password,
    ));

    response.fold((f) => emit(LoginFailure(f)), (r) => emit(const LoginSuccess()));
  }

  Future<void> _signInHandler(
      SignInEvent event, Emitter<LoginState> emit) async {
    emit(const LoggingIn());

    Map<String, String> params = {
      'email': event.email,
      'password': event.password,
    };
    final response = await _signIn(params);

    response.fold((f) => emit(LoginFailure(f)), (r) => emit(const LoginSuccess()));
  }

  Future<void> _signInWithGoogleHandler(
      SignInWithGoogleEvent event, Emitter<LoginState> emit) async {
    emit(const LoggingIn());

    final response = await _signInWithGoogle();

    response.fold((f) {
      if (f.statusCode == 'cancelled') {
        emit(LoginInitial());
      } else {
        emit(LoginFailure(f));
      }
    }, (r) => emit(const LoginSuccess()));
  }
}
