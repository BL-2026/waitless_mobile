import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/forgot_password.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({required ForgotPassword forgotPassword})
      : _forgotPassword = forgotPassword,
        super(ForgotPasswordInitial());

  final ForgotPassword _forgotPassword;

  Future<void> forgotPassword(String email) async {
    emit(const SendingEmail());

    final response = await _forgotPassword(email);

    response.fold((f) => emit(ForgotPasswordFailure(f)),
        (r) => emit(const ForgotPasswordEmailSent()));
  }
}
