import 'package:waitless_mobile/src/domain/repositories/auth_repository.dart';
import 'package:waitless_mobile/src/domain/usecases/usecase.dart';
import 'package:waitless_mobile/src/utils/typedef.dart';

class ForgotPassword extends UseCaseWithParams<void, String> {
  AuthRepository authRepository;

  ForgotPassword(this.authRepository);

  @override
  ResultFuture<void> call(String params) async =>
      await authRepository.forgotPassword(params);
}
