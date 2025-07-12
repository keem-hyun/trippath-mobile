import '../../domain/models/trip.dart';

abstract class TripDataSource {
  Future<Trip> createTrip(Trip trip);
  Future<void> deleteTrip(String tripId);
  Future<Trip?> getTripById(String tripId);
  Future<List<Trip>> getTrips(String userId);
  Future<Trip> updateTrip(Trip trip);
}