import 'package:injectable/injectable.dart';
import '../../domain/models/schedule.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule_datasource.dart';
import '../entities/schedule_entity.dart';

@LazySingleton(as: ScheduleRepository)
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleDataSource dataSource;

  ScheduleRepositoryImpl(this.dataSource);

  @override
  Future<Schedule> createSchedule(Schedule schedule) async {
    try {
      final entity = ScheduleEntity.fromDomain(schedule);
      final createdEntity = await dataSource.createSchedule(entity);
      return createdEntity.toDomain();
    } catch (e) {
      throw Exception('Failed to create schedule: $e');
    }
  }

  @override
  Future<List<Schedule>> getSchedulesByTripId(String tripId) async {
    try {
      final entities = await dataSource.getSchedulesByTripId(tripId);
      return entities.map((entity) => entity.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get schedules: $e');
    }
  }

  @override
  Future<Schedule> updateSchedule(Schedule schedule) async {
    try {
      final entity = ScheduleEntity.fromDomain(schedule);
      final updatedEntity = await dataSource.updateSchedule(entity);
      return updatedEntity.toDomain();
    } catch (e) {
      throw Exception('Failed to update schedule: $e');
    }
  }

  @override
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await dataSource.deleteSchedule(scheduleId);
    } catch (e) {
      throw Exception('Failed to delete schedule: $e');
    }
  }
}