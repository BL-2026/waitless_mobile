import 'package:waitless_mobile/src/domain/repositories/auth_repository.dart';
import 'package:waitless_mobile/src/domain/usecases/usecase.dart';
import 'package:waitless_mobile/src/utils/typedef.dart';

class SignInWithGoogle extends UseCaseWithoutParams<void> {
  SignInWithGoogle(this.authRepository);

  final AuthRepository authRepository;

  @override
  ResultFuture<void> call() => authRepository.signInWithGoogle();
}
