import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../models/schedule.dart';
import '../repositories/schedule_repository.dart';

@injectable
class GetScheduleUseCase {
  final ScheduleRepository repository;

  GetScheduleUseCase(this.repository);

  Future<Either<Exception, List<Schedule>>> call(String tripId) async {
    try {
      final schedules = await repository.getSchedulesByTripId(tripId);
      return Right(schedules);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}