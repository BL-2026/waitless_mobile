import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode});
  final String message;
  final String statusCode;

  String get errorMessage => 'status Code : $statusCode, ERROR: $message';

  @override
  List<Object> get props => [message, statusCode];
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});
  ApiFailure.fromException(ApiFailure exception)
      : this(message: exception.message, statusCode: exception.statusCode);
}
