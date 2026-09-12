import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/sign_up.dart';
import 'package:equatable/equatable.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/sign_in.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this._signIn, required this._signUp})
      : super(LoginInitial()) {
    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
  }

  final SignIn _signIn;
  final SignUp _signUp;

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

    response.fold((f) => emit(LoginFailure(f.message)),
        (r) => emit(const LoginSuccess()));
  }

  Future<void> _signInHandler(
      SignInEvent event, Emitter<LoginState> emit) async {
    emit(const LoggingIn());

    Map<String, String> params = {
      'email': event.email,
      'password': event.password,
    };
    final response = await _signIn(params);

    response.fold((f) => emit(LoginFailure(f.message)),
        (r) => emit(const LoginSuccess()));
  }
}
