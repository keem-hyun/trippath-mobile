import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/user.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const UserEntity._();
  
  const factory UserEntity({
    required String id,
    required String email,
    required String name,
    String? profileImageUrl,
    required String provider,
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

  User toModel() {
    return User(
      id: id,
      email: email,
      name: name,
      profileImageUrl: profileImageUrl,
      provider: AuthProvider.values.firstWhere(
        (e) => e.name == provider,
        orElse: () => AuthProvider.google,
      ),
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
    );
  }

  factory UserEntity.fromModel(User user) {
    return UserEntity(
      id: user.id,
      email: user.email,
      name: user.name,
      profileImageUrl: user.profileImageUrl,
      provider: user.provider.name,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
    );
  }
}