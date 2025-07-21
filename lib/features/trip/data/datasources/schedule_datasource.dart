import '../entities/schedule_entity.dart';

abstract class ScheduleDataSource {
  Future<ScheduleEntity> createSchedule(ScheduleEntity schedule);
  Future<List<ScheduleEntity>> getSchedulesByTripId(String tripId);
  Future<ScheduleEntity> updateSchedule(ScheduleEntity schedule);
  Future<void> deleteSchedule(String scheduleId);
}