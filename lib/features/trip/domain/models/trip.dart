import 'package:freezed_annotation/freezed_annotation.dart';
import 'schedule.dart';

part 'trip.freezed.dart';

@freezed
class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String userId,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required String description,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default({}) Map<String, List<Schedule>> schedules, // Date string (yyyy-MM-dd) -> List of schedules
  }) = _Trip;
}