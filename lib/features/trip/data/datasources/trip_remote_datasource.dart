import 'package:injectable/injectable.dart';
import '../../domain/models/trip.dart';
import 'trip_datasource.dart';

// This is a placeholder for future remote implementation
// To use this, change the @Injectable annotation in TripLocalDataSource
// and add @Injectable(as: TripDataSource) to this class instead
class TripRemoteDataSource implements TripDataSource {
  // TODO: Add API client dependency
  
  @override
  Future<Trip> createTrip(Trip trip) async {
    // TODO: Implement API call to create trip
    throw UnimplementedError('Remote data source not implemented yet');
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    // TODO: Implement API call to delete trip
    throw UnimplementedError('Remote data source not implemented yet');
  }

  @override
  Future<Trip?> getTripById(String tripId) async {
    // TODO: Implement API call to get trip by ID
    throw UnimplementedError('Remote data source not implemented yet');
  }

  @override
  Future<List<Trip>> getTrips(String userId) async {
    // TODO: Implement API call to get user's trips
    throw UnimplementedError('Remote data source not implemented yet');
  }

  @override
  Future<Trip> updateTrip(Trip trip) async {
    // TODO: Implement API call to update trip
    throw UnimplementedError('Remote data source not implemented yet');
  }
}