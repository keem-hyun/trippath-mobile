import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../entities/user_entity.dart';
import 'auth_datasource.dart';
import '../../../../shared/services/auth/token_service.dart';

@Injectable(as: AuthDataSource)
@Environment(Environment.test)
class AuthMockDataSource implements AuthDataSource {
  final GoogleSignIn _googleSignIn;
  final TokenService _tokenService;

  AuthMockDataSource(
    @Named('googleSignIn') this._googleSignIn,
    this._tokenService,
  );

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
    
    // Generate mock tokens
    final mockTokens = TokenService.generateMockTokens('mock_${googleUser.id}');
    
    return UserEntity(
      id: 'mock_${googleUser.id}',
      email: googleUser.email,
      name: googleUser.displayName ?? 'Unknown User',
      profileImageUrl: googleUser.photoUrl,
      provider: 'google',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      accessToken: mockTokens.accessToken,
      refreshToken: mockTokens.refreshToken,
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
    // First check if we have stored tokens
    final hasTokens = await _tokenService.hasValidTokens();
    
    if (!hasTokens) {
      return null;
    }
    
    // Check if access token is still valid
    final isTokenValid = await _tokenService.isAccessTokenValid();
    
    if (!isTokenValid) {
      // Try to refresh token
      final newAccessToken = await _tokenService.refreshAccessToken();
      if (newAccessToken == null) {
        // Refresh failed, clear tokens
        await _tokenService.clearTokens();
        return null;
      }
    }
    
    // Try to get user from Google Sign In for profile info
    GoogleSignInAccount? currentUser = _googleSignIn.currentUser;
    
    // If not in memory, try silent sign in
    if (currentUser == null) {
      try {
        currentUser = await _googleSignIn.signInSilently();
      } catch (e) {
        // Silent sign in failed, but we have valid backend tokens
        // In real implementation, we should get user info from backend
        // For now, return null to clear tokens
        await _tokenService.clearTokens();
        return null;
      }
    }
    
    if (currentUser != null) {
      // Simulate network delay for backend API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get current tokens (might be refreshed)
      final accessToken = await _tokenService.getAccessToken();
      final refreshToken = await _tokenService.getRefreshToken();
      
      return UserEntity(
        id: 'mock_${currentUser.id}',
        email: currentUser.email,
        name: currentUser.displayName ?? 'Unknown User',
        profileImageUrl: currentUser.photoUrl,
        provider: 'google',
        createdAt: DateTime.now().subtract(const Duration(days: 30)), // Mock created date
        lastLoginAt: DateTime.now(),
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
    
    // No user found, clear tokens
    await _tokenService.clearTokens();
    return null;
  }
}