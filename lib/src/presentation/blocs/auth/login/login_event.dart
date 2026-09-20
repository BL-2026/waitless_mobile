part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends LoginEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpEvent extends LoginEvent {
  final String fullName;

  /// Dial code including the plus sign, e.g. `+212`.
  final String phoneArea;

  /// National part without the dial code, e.g. `612345678`.
  final String phoneNumber;
  final String email;
  final String password;

  const SignUpEvent({
    required this.fullName,
    required this.phoneArea,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props =>
      [fullName, phoneArea, phoneNumber, email, password];
}

class ForgotPasswordEvent extends LoginEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});
}

class SignInWithGoogleEvent extends LoginEvent {
  const SignInWithGoogleEvent();
}
