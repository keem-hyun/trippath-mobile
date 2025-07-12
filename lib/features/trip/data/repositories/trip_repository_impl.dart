import 'package:injectable/injectable.dart';
import '../../domain/models/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_datasource.dart';

@Injectable(as: TripRepository)
class TripRepositoryImpl implements TripRepository {
  final TripDataSource _dataSource;

  TripRepositoryImpl(this._dataSource);

  @override
  Future<Trip> createTrip(Trip trip) async {
    return await _dataSource.createTrip(trip);
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    return await _dataSource.deleteTrip(tripId);
  }

  @override
  Future<Trip?> getTripById(String tripId) async {
    return await _dataSource.getTripById(tripId);
  }

  @override
  Future<List<Trip>> getTrips(String userId) async {
    return await _dataSource.getTrips(userId);
  }

  @override
  Future<Trip> updateTrip(Trip trip) async {
    return await _dataSource.updateTrip(trip);
  }
}