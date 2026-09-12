import 'package:equatable/equatable.dart';
import 'package:waitless_mobile/src/domain/repositories/auth_repository.dart';
import 'package:waitless_mobile/src/domain/usecases/usecase.dart';
import 'package:waitless_mobile/src/utils/typedef.dart';

class SignUpParams extends Equatable {
  final String fullName;

  /// Dial code including the plus sign, e.g. `+212`.
  final String phoneArea;

  /// National part without the dial code, e.g. `612345678`.
  final String phoneNumber;
  final String email;
  final String password;

  const SignUpParams({
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

class SignUp extends UseCaseWithParams<void, SignUpParams> {
  AuthRepository authRepository;

  SignUp(this.authRepository);

  @override
  ResultFuture<void> call(SignUpParams params) async {
    return await authRepository.signUp(
      fullName: params.fullName,
      phoneArea: params.phoneArea,
      phoneNumber: params.phoneNumber,
      email: params.email,
      password: params.password,
    );
  }
}
