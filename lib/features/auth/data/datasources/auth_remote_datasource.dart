import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/network/api_client.dart';
import '../entities/user_entity.dart';
import 'auth_datasource.dart';
import '../../../../shared/services/auth/token_service.dart';

@Injectable(as: AuthDataSource)
@Environment(Environment.dev)
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

    // Clear access token first to force refresh
    await googleUser.clearAuthCache();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    // Send token to backend
    try {
      print('📡 Sending auth request to: ${_apiClient.dio.options.baseUrl}/auth/mobile/google/token');
      print('📤 Request data: email=${googleUser.email}');
      print('🔐 idToken: ${googleAuth.idToken}');
      
      final response = await _apiClient.dio.post(
        '/auth/mobile/google/token',
        data: {
          'idToken': googleAuth.idToken,
          'email': googleUser.email,
        },
      );
      
      print('✅ Auth response: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final accessToken = response.data['accessToken'];
        final refreshToken = response.data['refreshToken'];
        final email = response.data['email'];
        final name = response.data['name'];
        
        // Create UserEntity with response data
        return UserEntity(
          id: googleUser.id, // Use Google user ID
          email: email,
          name: name,
          profileImageUrl: googleUser.photoUrl,
          provider: 'google',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } else {
        print('❌ Auth failed with status: ${response.statusCode}');
        throw Exception('Authentication failed: ${response.statusMessage}');
      }
    } catch (e) {
      print('💥 Auth request error: $e');
      if (e.toString().contains('Connection refused')) {
        print('🔗 Check if API server is running at: ${_apiClient.dio.options.baseUrl}');
        throw Exception('Connection refused');
      } else if (e is DioException && e.response != null) {
        print('🔍 Error response status: ${e.response?.statusCode}');
        print('🔍 Error response data: ${e.response?.data}');
        print('🔍 Error response headers: ${e.response?.headers}');
        
        // 서버에서 온 에러 메시지 사용
        if (e.response?.data is Map<String, dynamic>) {
          final errorData = e.response!.data as Map<String, dynamic>;
          final message = errorData['message'] ?? 'Unknown error';
          final code = errorData['code'] ?? 'UNKNOWN';
          throw Exception('[$code] $message');
        }
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    // Backend logout
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken != null) {
        print('📤 Sending logout request with refresh token');
        await _apiClient.dio.post(
          '/auth/mobile/logout',
          options: Options(
            headers: {
              'x-refresh-token': refreshToken,
            },
          ),
        );
        print('✅ Logout successful');
      }
    } catch (e) {
      print('💥 Logout request error: $e');
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