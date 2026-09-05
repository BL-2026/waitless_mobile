import 'package:waitless_mobile/src/domain/repositories/auth_repository.dart';
import 'package:waitless_mobile/src/domain/usecases/usecase.dart';
import 'package:waitless_mobile/src/utils/typedef.dart';

class Logout extends UseCaseWithoutParams<void> {
  AuthRepository authRepository;

  Logout(this.authRepository);

  @override
  ResultFuture<void> call() async => await authRepository.logout();
}
