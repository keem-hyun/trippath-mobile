import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;
  User? _currentUser;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<String, User>> signInWithGoogle() async {
    try {
      final userEntity = await _dataSource.signInWithGoogle();
      _currentUser = userEntity.toModel();
      return Right(_currentUser!);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await _dataSource.signOut();
      _currentUser = null;
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, User?>> getCurrentUser() async {
    try {
      final userEntity = await _dataSource.getCurrentUser();
      if (userEntity != null) {
        _currentUser = userEntity.toModel();
        return Right(_currentUser);
      }
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<User?> authStateChanges() {
    // For now, return a simple stream
    // In production, this could be connected to WebSocket or SSE
    return Stream.value(_currentUser);
  }
}