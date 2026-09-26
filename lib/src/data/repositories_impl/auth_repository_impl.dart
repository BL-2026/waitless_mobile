import 'package:dartz/dartz.dart';
import 'package:waitless_mobile/src/data/sources/network/account/account_remote_data_source.dart';
import 'package:waitless_mobile/src/data/sources/network/auth/auth_remote_data_source.dart';
import 'package:waitless_mobile/src/domain/entities/account.dart';
import 'package:waitless_mobile/src/domain/repositories/auth_repository.dart';
import 'package:waitless_mobile/src/exceptions/app_error_code.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';
import 'package:waitless_mobile/src/exceptions/sign_in_cancelled.dart';
import 'package:waitless_mobile/src/exceptions/user_not_found.dart';
import 'package:waitless_mobile/src/services/staff_session.dart';
import 'package:waitless_mobile/src/utils/typedef.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final AccountRemoteDataSource _accountDataSource;
  final StaffSession _session;

  const AuthRepositoryImpl(
      this._dataSource, this._accountDataSource, this._session);

  ApiFailure _wrap(Failure e) => ApiFailure(
        message: e.message,
        statusCode: e.statusCode,
        code: e.code,
      );

  @override
  ResultFuture<void> signUp({
    required String fullName,
    required String phoneArea,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      await _dataSource.signUp(
          fullName: fullName, email: email, password: password);
    } on ApiFailure catch (e) {
      return Left(_wrap(e));
    }

    try {
      await _accountDataSource.createAccount(CreateAccountRequest(
        fullName: fullName,
        phoneArea: phoneArea,
        phoneNumber: phoneNumber,
        email: email,
      ));
      return const Right(null);
    } on ApiFailure catch (e) {
      // A Firebase identity with no backend account can never sign in usefully, and
      // it holds the e-mail hostage. Undo it so the owner can just try again.
      await _rollBackFirebaseUser();
      return Left(_wrap(e));
    } catch (e) {
      await _rollBackFirebaseUser();
      return Left(ApiFailure(
        message: e.toString(),
        statusCode: '500',
        code: AppErrorCode.internalError,
      ));
    }
  }

  Future<void> _rollBackFirebaseUser() async {
    try {
      await _dataSource.deleteCurrentUser();
    } on Failure {
      // Nothing more we can do here; the original error is the one worth showing.
    }
  }

  @override
  ResultFuture<void> signIn(String email, String password) async {
    try {
      await _dataSource.signIn(email, password);

      // Idempotent on the Firebase UID. Calling it here means an identity created
      // before the backend existed still gets its Postgres row on next sign-in.
      await _accountDataSource.createAccount(const CreateAccountRequest());

      return const Right(null);
    } on UserNotFound catch (e) {
      return Left(_wrap(e));
    } on ApiFailure catch (e) {
      return Left(_wrap(e));
    }
  }

  @override
  ResultFuture<void> signInWithGoogle() async {
    try {
      await _dataSource.signInWithGoogle();
      await _accountDataSource.createAccount(const CreateAccountRequest());
      return const Right(null);
    } on SignInCancelled catch (e) {
      return Left(_wrap(e));
    } on UserNotFound catch (e) {
      return Left(_wrap(e));
    } on ApiFailure catch (e) {
      return Left(_wrap(e));
    }
  }

  @override
  ResultFuture<void> forgotPassword(String email) async {
    try {
      final result = await _dataSource.forgotPassword(email);

      return Right(result);
    } on UserNotFound catch (e) {
      return Left(_wrap(e));
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      final result = await _dataSource.logout();
      // Signing out ends the shift: the next person has to re-enter their PIN.
      _session.clear();

      return Right(result);
    } on UserNotFound catch (e) {
      return Left(_wrap(e));
    }
  }
}
