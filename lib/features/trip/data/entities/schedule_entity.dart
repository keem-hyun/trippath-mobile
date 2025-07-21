import 'package:json_annotation/json_annotation.dart';
import '../../domain/models/schedule.dart';

part 'schedule_entity.g.dart';

@JsonSerializable()
class ScheduleEntity {
  final String id;
  final String tripId;
  final String title;
  @JsonKey(name: 'date')
  final String dateString;
  final String time;
  final List<String> locations;
  final String? description;
  final double? cost;
  @JsonKey(name: 'created_at')
  final String createdAtString;
  @JsonKey(name: 'updated_at')
  final String? updatedAtString;

  const ScheduleEntity({
    required this.id,
    required this.tripId,
    required this.title,
    required this.dateString,
    required this.time,
    required this.locations,
    this.description,
    this.cost,
    required this.createdAtString,
    this.updatedAtString,
  });

  factory ScheduleEntity.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleEntityToJson(this);

  Schedule toDomain() {
    return Schedule(
      id: id,
      tripId: tripId,
      title: title,
      date: DateTime.parse(dateString),
      time: time,
      locations: locations,
      description: description,
      cost: cost,
      createdAt: DateTime.parse(createdAtString),
      updatedAt: updatedAtString != null ? DateTime.parse(updatedAtString!) : null,
    );
  }

  factory ScheduleEntity.fromDomain(Schedule schedule) {
    return ScheduleEntity(
      id: schedule.id,
      tripId: schedule.tripId,
      title: schedule.title,
      dateString: schedule.date.toIso8601String(),
      time: schedule.time,
      locations: schedule.locations,
      description: schedule.description,
      cost: schedule.cost,
      createdAtString: schedule.createdAt.toIso8601String(),
      updatedAtString: schedule.updatedAt?.toIso8601String(),
    );
  }
}