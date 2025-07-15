import 'package:dartz/dartz.dart';
import '../models/schedule.dart';
import '../repositories/schedule_repository.dart';

class CreateScheduleUseCase {
  final ScheduleRepository repository;

  CreateScheduleUseCase(this.repository);

  Future<Either<Exception, Schedule>> call(Schedule schedule) async {
    try {
      final createdSchedule = await repository.createSchedule(schedule);
      return Right(createdSchedule);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}