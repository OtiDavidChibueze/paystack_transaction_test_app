import 'package:fpdart/fpdart.dart';

abstract class UseCase<F, T, P> {
  Future<Either<F, T>> call(P params);
}

class NoParams {}
