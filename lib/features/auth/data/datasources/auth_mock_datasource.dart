import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../entities/user_entity.dart';
import 'auth_datasource.dart';

@Injectable(as: AuthDataSource)
@Environment(Environment.dev)
@Environment(Environment.test)
class AuthMockDataSource implements AuthDataSource {
  final GoogleSignIn _googleSignIn;

  AuthMockDataSource(@Named('googleSignIn') this._googleSignIn);

  @override
  Future<UserEntity> signInWithGoogle() async {
    // Use real Google Sign In SDK
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) {
      throw Exception('Google sign in cancelled');
    }

    // Instead of calling backend API, return mock data
    // but use real Google account info
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    return UserEntity(
      id: 'mock_${googleUser.id}',
      email: googleUser.email,
      name: googleUser.displayName ?? 'Unknown User',
      profileImageUrl: googleUser.photoUrl,
      provider: 'google',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    // Simulate network delay for backend logout
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // Check if user is signed in with Google
    final currentUser = _googleSignIn.currentUser;
    
    if (currentUser != null) {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      return UserEntity(
        id: 'mock_${currentUser.id}',
        email: currentUser.email,
        name: currentUser.displayName ?? 'Unknown User',
        profileImageUrl: currentUser.photoUrl,
        provider: 'google',
        createdAt: DateTime.now().subtract(const Duration(days: 30)), // Mock created date
        lastLoginAt: DateTime.now(),
      );
    }
    
    return null;
  }
}