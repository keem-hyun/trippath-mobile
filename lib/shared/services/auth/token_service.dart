import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../storage/secure_storage_service.dart';
import '../../../core/network/api_client.dart';

@singleton
class TokenService {
  final SecureStorageService _secureStorage;
  final ApiClient _apiClient;

  TokenService(this._secureStorage, this._apiClient);

  // Token management
  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) async {
    await _secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    
    if (userId != null) {
      await _secureStorage.saveUserId(userId);
    }
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.getRefreshToken();
  }

  Future<bool> hasValidTokens() async {
    return await _secureStorage.hasTokens();
  }

  Future<void> clearTokens() async {
    await _secureStorage.deleteTokens();
    await _secureStorage.deleteUserId();
  }

  // Token validation
  Future<bool> isAccessTokenValid() async {
    final token = await getAccessToken();
    if (token == null) return false;
    
    // JWT 토큰인 경우 로컬에서 만료 시간 확인
    if (token.contains('.')) {
      try {
        return _isJwtTokenValid(token);
      } catch (e) {
        return false;
      }
    }
    
    // Mock 토큰의 경우 생성 시간 기반 검증
    if (token.startsWith('mock_access_token_')) {
      final parts = token.split('_');
      if (parts.length >= 4) {
        final timestamp = int.tryParse(parts.last);
        if (timestamp != null) {
          final createdAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final now = DateTime.now();
          return now.difference(createdAt).inHours < 1; // 1시간 만료
        }
      }
    }
    
    return false;
  }
  
  bool _isJwtTokenValid(String token) {
    // JWT 토큰 파싱 (base64 디코딩)
    final parts = token.split('.');
    if (parts.length != 3) return false;
    
    // payload 부분 디코딩
    final payload = parts[1];
    // Base64 패딩 추가
    final normalized = base64.normalize(payload);
    final decoded = utf8.decode(base64.decode(normalized));
    final Map<String, dynamic> payloadMap = json.decode(decoded);
    
    // exp (만료 시간) 확인
    final exp = payloadMap['exp'] as int?;
    if (exp == null) return false;
    
    final expirationTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final now = DateTime.now();
    
    return now.isBefore(expirationTime);
  }

  Future<String?> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return null;
    
    // For production: refresh with backend API
    try {
      final response = await _apiClient.dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });
      
      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];
        
        await saveAuthTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        
        return newAccessToken;
      }
    } catch (e) {
      // If API call fails, fallback to mock for dev/test
      if (refreshToken.startsWith('mock_refresh_token_')) {
        final newTokens = generateMockTokens('refreshed_user');
        await saveAuthTokens(
          accessToken: newTokens.accessToken,
          refreshToken: newTokens.refreshToken,
        );
        return newTokens.accessToken;
      }
    }
    
    return null;
  }

  // For mock implementation - generate fake tokens
  static AuthTokens generateMockTokens(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return AuthTokens(
      accessToken: 'mock_access_token_${userId}_$timestamp',
      refreshToken: 'mock_refresh_token_${userId}_$timestamp',
      expiresIn: 3600, // 1 hour
    );
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });
}