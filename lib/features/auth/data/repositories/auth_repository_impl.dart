import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../../../../shared/services/auth/token_service.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;
  final TokenService _tokenService;
  User? _currentUser;

  AuthRepositoryImpl(this._dataSource, this._tokenService);

  @override
  Future<Either<String, User>> signInWithGoogle() async {
    try {
      final userEntity = await _dataSource.signInWithGoogle();
      
      // Save tokens if available
      if (userEntity.accessToken != null && userEntity.refreshToken != null) {
        await _tokenService.saveAuthTokens(
          accessToken: userEntity.accessToken!,
          refreshToken: userEntity.refreshToken!,
          userId: userEntity.id,
        );
      }
      
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
      await _tokenService.clearTokens(); // Clear stored tokens
      _currentUser = null;
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, User?>> getCurrentUser() async {
    try {
      // First check if we have tokens stored
      final hasTokens = await _tokenService.hasValidTokens();
      
      if (hasTokens) {
        // Try to get current user with stored tokens
        final userEntity = await _dataSource.getCurrentUser();
        if (userEntity != null) {
          _currentUser = userEntity.toModel();
          return Right(_currentUser);
        }
      }
      
      // No tokens or user not found
      await _tokenService.clearTokens();
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