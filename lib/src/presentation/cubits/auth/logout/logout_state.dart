part of 'logout_cubit.dart';

sealed class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

final class LogoutInitial extends LogoutState {}

class LogoutInProgress extends LogoutState {
  const LogoutInProgress();
}

class LogoutSuccess extends LogoutState {
  const LogoutSuccess();
}

class LogoutFailure extends LogoutState {
  final String errorMessage;

  const LogoutFailure(this.errorMessage);
}
