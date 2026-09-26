import 'package:waitless_mobile/src/domain/usecases/auth/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:waitless_mobile/src/data/repositories_impl/api_request_repository_impl.dart';
import 'package:waitless_mobile/src/data/repositories_impl/auth_repository_impl.dart';
import 'package:waitless_mobile/src/data/sources/network/account/account_api_remote_data_source_impl.dart';
import 'package:waitless_mobile/src/data/sources/network/account/account_remote_data_source.dart';
import 'package:waitless_mobile/src/data/sources/network/api_client.dart';
import 'package:waitless_mobile/src/data/sources/network/auth/auth_firebase_remote_data_source_impl.dart';
import 'package:waitless_mobile/src/data/sources/network/auth/auth_remote_data_source.dart';
import 'package:waitless_mobile/src/data/sources/network/request/request_remote_data_source.dart';
import 'package:waitless_mobile/src/data/sources/network/staff/staff_remote_data_source.dart';
import 'package:waitless_mobile/src/data/sources/network/store/store_remote_data_source.dart';
import 'package:waitless_mobile/src/domain/repositories/auth_repository.dart';
import 'package:waitless_mobile/src/domain/repositories/request_repository.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/forgot_password.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/logout.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/sign_in.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/sign_in_with_google.dart';
import 'package:waitless_mobile/src/domain/usecases/request_usecases.dart';
import 'package:waitless_mobile/src/presentation/blocs/auth/login/login_bloc.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/forgot_password/forgot_password_cubit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:waitless_mobile/src/presentation/cubits/auth/logout/logout_cubit.dart';
import 'package:waitless_mobile/src/presentation/cubits/language/language_cubit.dart';
import 'package:waitless_mobile/src/presentation/cubits/requests/requests_cubit.dart';
import 'package:waitless_mobile/src/services/staff_session.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // AUTH
  sl
    //Business Logic
    ..registerFactory(() => LoginBloc(
          signIn: sl(),
          signUp: sl(),
          signInWithGoogle: sl(),
        ))
    ..registerFactory(() => ForgotPasswordCubit(forgotPassword: sl()))
    ..registerFactory(() => LogoutCubit(logout: sl()))
    ..registerLazySingleton(LanguageCubit.new)
    //Usecases
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignInWithGoogle(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => Logout(sl()))
    //Repositories
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl(), sl()))
    //DataSource
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthFirebaseRemoteDataSourceImpl(sl(), sl()))
    ..registerLazySingleton<AccountRemoteDataSource>(
      () => AccountApiRemoteDataSourceImpl(sl()));

  // FLOOR — venue, staff and the live request queue
  sl
    //Business Logic
    ..registerFactory(() => RequestsCubit(
          watchActiveRequests: sl(),
          acknowledgeRequest: sl(),
          resolveRequest: sl(),
        ))
    //Usecases
    ..registerLazySingleton(() => WatchActiveRequestsUseCase(sl()))
    ..registerLazySingleton(() => AcknowledgeRequestUseCase(sl()))
    ..registerLazySingleton(() => ResolveRequestUseCase(sl()))
    //Repositories
    ..registerLazySingleton<RequestRepository>(
      () => ApiRequestRepositoryImpl(sl(), sl(), sl()))
    //DataSource
    ..registerLazySingleton<StoreRemoteDataSource>(
      () => StoreApiRemoteDataSourceImpl(sl()))
    ..registerLazySingleton<StaffRemoteDataSource>(
      () => StaffApiRemoteDataSourceImpl(sl()))
    ..registerLazySingleton<RequestRemoteDataSource>(
      () => RequestApiRemoteDataSourceImpl(sl()));

  sl
    //External dependencies
    ..registerLazySingleton(StaffSession.new)
    ..registerLazySingleton(() => WaitlessApiClient(sl(), sl()))
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(
      () => GoogleSignIn(scopes: const ['email', 'profile']),
    )
    ..registerLazySingleton(http.Client.new);
}
