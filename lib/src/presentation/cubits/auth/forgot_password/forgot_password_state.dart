part of 'forgot_password_cubit.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

final class ForgotPasswordInitial extends ForgotPasswordState {}

class SendingEmail extends ForgotPasswordState {
  const SendingEmail();
}

class ForgotPasswordEmailSent extends ForgotPasswordState {
  const ForgotPasswordEmailSent();
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final Failure failure;

  const ForgotPasswordFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
