import '../models/schedule.dart';

abstract class ScheduleRepository {
  Future<Schedule> createSchedule(Schedule schedule);
  Future<List<Schedule>> getSchedulesByTripId(String tripId);
  Future<Schedule> updateSchedule(Schedule schedule);
  Future<void> deleteSchedule(String scheduleId);
}