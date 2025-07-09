import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/network/api_client.dart';
import '../entities/user_entity.dart';
import 'auth_datasource.dart';
import '../../../../shared/services/auth/token_service.dart';

@Injectable(as: AuthDataSource)
@Environment(Environment.prod)
class AuthRemoteDataSource implements AuthDataSource {
  final ApiClient _apiClient;
  final GoogleSignIn _googleSignIn;
  final TokenService _tokenService;

  AuthRemoteDataSource(
    this._apiClient,
    @Named('googleSignIn') this._googleSignIn,
    this._tokenService,
  );

  @override
  Future<UserEntity> signInWithGoogle() async {
    // Google Sign In
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) {
      throw Exception('Google sign in cancelled');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    // Send token to backend
    final response = await _apiClient.dio.post(
      '/auth/google',
      data: {
        'idToken': googleAuth.idToken,
        'accessToken': googleAuth.accessToken,
      },
    );

    if (response.statusCode == 200) {
      final userData = response.data['user'];
      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];
      
      // Create UserEntity with tokens
      return UserEntity.fromJson({
        ...userData,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      });
    } else {
      throw Exception('Authentication failed: ${response.statusMessage}');
    }
  }

  @override
  Future<void> signOut() async {
    // Backend logout
    try {
      await _apiClient.dio.post('/auth/logout');
    } catch (e) {
      // Continue with logout even if backend call fails
    }
    
    // Google Sign Out
    await _googleSignIn.signOut();
    
    // Clear local tokens
    await _tokenService.clearTokens();
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
    
    // Get current user from backend
    try {
      final response = await _apiClient.dio.get('/auth/me');
      
      if (response.statusCode == 200 && response.data != null) {
        final userData = response.data['user'];
        final accessToken = await _tokenService.getAccessToken();
        final refreshToken = await _tokenService.getRefreshToken();
        
        // Return user with current tokens
        return UserEntity.fromJson({
          ...userData,
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        });
      }
    } catch (e) {
      // API call failed, clear tokens
      await _tokenService.clearTokens();
    }
    
    return null;
  }
}