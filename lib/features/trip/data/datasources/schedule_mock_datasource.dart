import 'package:injectable/injectable.dart';
import '../entities/schedule_entity.dart';
import 'schedule_datasource.dart';

@LazySingleton(as: ScheduleDataSource)
class ScheduleMockDataSource implements ScheduleDataSource {
  final List<ScheduleEntity> _schedules = [];

  @override
  Future<ScheduleEntity> createSchedule(ScheduleEntity schedule) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newSchedule = ScheduleEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tripId: schedule.tripId,
      title: schedule.title,
      dateString: schedule.dateString,
      time: schedule.time,
      locations: schedule.locations,
      description: schedule.description,
      cost: schedule.cost,
      createdAtString: DateTime.now().toIso8601String(),
      updatedAtString: null,
    );
    
    _schedules.add(newSchedule);
    return newSchedule;
  }

  @override
  Future<List<ScheduleEntity>> getSchedulesByTripId(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _schedules.where((schedule) => schedule.tripId == tripId).toList();
  }

  @override
  Future<ScheduleEntity> updateSchedule(ScheduleEntity schedule) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _schedules.indexWhere((s) => s.id == schedule.id);
    if (index == -1) {
      throw Exception('Schedule not found');
    }
    
    final updatedSchedule = ScheduleEntity(
      id: schedule.id,
      tripId: schedule.tripId,
      title: schedule.title,
      dateString: schedule.dateString,
      time: schedule.time,
      locations: schedule.locations,
      description: schedule.description,
      cost: schedule.cost,
      createdAtString: schedule.createdAtString,
      updatedAtString: DateTime.now().toIso8601String(),
    );
    
    _schedules[index] = updatedSchedule;
    return updatedSchedule;
  }

  @override
  Future<void> deleteSchedule(String scheduleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _schedules.removeWhere((schedule) => schedule.id == scheduleId);
  }
}