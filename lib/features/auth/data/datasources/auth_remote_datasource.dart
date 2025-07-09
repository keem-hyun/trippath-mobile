import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/network/api_client.dart';
import '../entities/user_entity.dart';
import 'auth_datasource.dart';

@Injectable(as: AuthDataSource)
@Environment(Environment.prod)
class AuthRemoteDataSource implements AuthDataSource {
  final ApiClient _apiClient;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource(
    this._apiClient,
    @Named('googleSignIn') this._googleSignIn,
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
      return UserEntity.fromJson(response.data['user']);
    } else {
      throw Exception('Authentication failed: ${response.statusMessage}');
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _apiClient.dio.post('/auth/logout');
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final response = await _apiClient.dio.get('/auth/me');
    
    if (response.statusCode == 200 && response.data != null) {
      return UserEntity.fromJson(response.data['user']);
    }
    return null;
  }
}