import 'package:waitless_mobile/src/domain/usecases/auth/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:waitless_mobile/src/data/repositories_impl/auth_repository_impl.dart';
import 'package:waitless_mobile/src/data/sources/network/auth/auth_firebase_remote_data_source_impl.dart';
import 'package:waitless_mobile/src/data/sources/network/auth/auth_remote_data_source.dart';
import 'package:waitless_mobile/src/domain/repositories/auth_repository.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/forgot_password.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/logout.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/sign_in.dart';
import 'package:waitless_mobile/src/presentation/blocs/auth/login/login_bloc.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/forgot_password/forgot_password_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:waitless_mobile/src/presentation/cubits/auth/logout/logout_cubit.dart';
import 'package:waitless_mobile/src/presentation/cubits/language/language_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // AUTH
  sl
    //Business Logic
    ..registerFactory(() => LoginBloc(signIn: sl(), signUp: sl()))
    ..registerFactory(() => ForgotPasswordCubit(forgotPassword: sl()))
    ..registerFactory(() => LogoutCubit(logout: sl()))
    ..registerLazySingleton(LanguageCubit.new)
    //Usecases
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => Logout(sl()))
    //Repositories
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    //DataSource
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthFirebaseRemoteDataSourceImpl(sl()));

  sl
    //External dependencies
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(http.Client.new);
}
