import 'package:waitless_mobile/src/domain/repositories/auth_repository.dart';
import 'package:waitless_mobile/src/domain/usecases/usecase.dart';
import 'package:waitless_mobile/src/utils/typedef.dart';

class SignIn extends UseCaseWithParams<void, Map<String, String>> {
  AuthRepository authRepository;

  SignIn(this.authRepository);

  @override
  ResultFuture<void> call(Map<String, String> params) async {
    return await authRepository.signIn(params['email']!, params['password']!);
  }
}
