import '../entities/user_entity.dart';

abstract class AuthDataSource {
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
}