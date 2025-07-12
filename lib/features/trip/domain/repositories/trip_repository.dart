import '../models/trip.dart';

abstract class TripRepository {
  Future<List<Trip>> getTrips(String userId);
  Future<Trip> createTrip(Trip trip);
  Future<Trip> updateTrip(Trip trip);
  Future<void> deleteTrip(String tripId);
  Future<Trip?> getTripById(String tripId);
}