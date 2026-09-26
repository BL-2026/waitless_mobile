import 'package:waitless_mobile/src/exceptions/failure.dart';

class UserNotFound extends Failure {
  const UserNotFound({
    required super.message,
    required super.statusCode,
    super.code,
  });
}
