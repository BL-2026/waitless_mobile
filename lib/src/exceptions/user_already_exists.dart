import 'package:waitless_mobile/src/exceptions/failure.dart';

class UserAlreadyExists extends Failure {
  const UserAlreadyExists({required super.message, required super.statusCode});
}
