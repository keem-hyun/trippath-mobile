import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Either<String, User?>> call() async {
    return await _repository.getCurrentUser();
  }
}