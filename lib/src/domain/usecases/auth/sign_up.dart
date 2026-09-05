import 'package:waitless_mobile/src/domain/repositories/auth_repository.dart';
import 'package:waitless_mobile/src/domain/usecases/usecase.dart';
import 'package:waitless_mobile/src/utils/typedef.dart';

class SignUp extends UseCaseWithParams<void, Map<String, dynamic>> {
  AuthRepository authRepository;

  SignUp(this.authRepository);

  @override
  ResultFuture<void> call(Map<String, dynamic> params) async {
    return await authRepository.signUp(
      params['phoneNumber']!, params['email']!, params['password']!);
  }
}
