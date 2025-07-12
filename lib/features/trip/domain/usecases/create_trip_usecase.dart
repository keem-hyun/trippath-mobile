import 'package:injectable/injectable.dart';
import '../models/trip.dart';
import '../repositories/trip_repository.dart';

@injectable
class CreateTripUseCase {
  final TripRepository _repository;

  CreateTripUseCase(this._repository);

  Future<Trip> call(Trip trip) async {
    return await _repository.createTrip(trip);
  }
}