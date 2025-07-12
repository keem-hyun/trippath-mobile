import 'package:injectable/injectable.dart';
import '../models/trip.dart';
import '../repositories/trip_repository.dart';

@injectable
class GetTripsUseCase {
  final TripRepository _repository;

  GetTripsUseCase(this._repository);

  Future<List<Trip>> call(String userId) async {
    return await _repository.getTrips(userId);
  }
}