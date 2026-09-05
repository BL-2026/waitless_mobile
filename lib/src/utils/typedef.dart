import 'package:dartz/dartz.dart';
import 'package:waitless_mobile/src/exceptions/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
