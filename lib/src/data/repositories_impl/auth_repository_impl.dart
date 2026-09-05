import 'package:dartz/dartz.dart';
import 'package:waitless_mobile/src/data/sources/network/auth/auth_remote_data_source.dart';
import 'package:waitless_mobile/src/domain/repositories/auth_repository.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/exceptions/user_not_found.dart';
import 'package:waitless_mobile/src/utils/typedef.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  ResultFuture<void> signUp(
      String phoneNumber, String email, String password) async {
    try {
      final result = await _dataSource.signUp(phoneNumber, email, password);

      return Right(result);
    } on ApiFailure catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> signIn(String email, String password) async {
    try {
      final result = await _dataSource.signIn(email, password);

      return Right(result);
    } on UserNotFound catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> forgotPassword(String email) async {
    try {
      final result = await _dataSource.forgotPassword(email);

      return Right(result);
    } on UserNotFound catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      final result = await _dataSource.logout();

      return Right(result);
    } on UserNotFound catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
