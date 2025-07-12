import 'package:injectable/injectable.dart';
import '../../domain/models/trip.dart';
import 'trip_datasource.dart';

@Injectable(as: TripDataSource)
class TripLocalDataSource implements TripDataSource {
  final List<Trip> _trips = [];

  @override
  Future<Trip> createTrip(Trip trip) async {
    _trips.add(trip);
    return trip;
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    _trips.removeWhere((trip) => trip.id == tripId);
  }

  @override
  Future<Trip?> getTripById(String tripId) async {
    try {
      return _trips.firstWhere((trip) => trip.id == tripId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Trip>> getTrips(String userId) async {
    return _trips.where((trip) => trip.userId == userId).toList();
  }

  @override
  Future<Trip> updateTrip(Trip trip) async {
    final index = _trips.indexWhere((t) => t.id == trip.id);
    if (index != -1) {
      _trips[index] = trip;
      return trip;
    }
    throw Exception('Trip not found');
  }
}