import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule.freezed.dart';

@freezed
class Schedule with _$Schedule {
  const factory Schedule({
    required String id,
    required String tripId,
    required String title,
    required DateTime date,
    required String time,
    required List<String> locations,
    String? description,
    double? cost,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Schedule;
}