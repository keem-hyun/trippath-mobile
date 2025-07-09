import 'package:dartz/dartz.dart';
import '../models/user.dart';

abstract class AuthRepository {
  Future<Either<String, User>> signInWithGoogle();
  Future<Either<String, void>> signOut();
  Future<Either<String, User?>> getCurrentUser();
  Stream<User?> authStateChanges();
}