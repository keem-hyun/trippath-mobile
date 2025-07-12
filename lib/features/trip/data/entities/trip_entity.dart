import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/trip.dart';

part 'trip_entity.freezed.dart';
part 'trip_entity.g.dart';

@freezed
class TripEntity with _$TripEntity {
  const TripEntity._();

  const factory TripEntity({
    required String id,
    required String userId,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required String description,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TripEntity;

  factory TripEntity.fromJson(Map<String, dynamic> json) =>
      _$TripEntityFromJson(json);

  Trip toModel() => Trip(
        id: id,
        userId: userId,
        name: name,
        startDate: startDate,
        endDate: endDate,
        description: description,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}