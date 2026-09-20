import 'package:waitless_mobile/src/exceptions/failure.dart';

class SignInCancelled extends Failure {
  const SignInCancelled()
      : super(message: 'cancelled', statusCode: 'cancelled');
}
