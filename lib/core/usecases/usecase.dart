import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart'; // for @immutable
import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

@immutable
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
