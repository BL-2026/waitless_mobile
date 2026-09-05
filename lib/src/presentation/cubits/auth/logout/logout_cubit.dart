import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waitless_mobile/src/domain/usecases/auth/logout.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit({required this._logout})
      : super(LogoutInitial());

  final Logout _logout;

  Future<void> logout() async {
    emit(const LogoutInProgress());

    final response = await _logout();

    response.fold((f) => emit(LogoutFailure(f.message)),
        (r) => emit(const LogoutSuccess()));
  }
}
