import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../domain/models/trip.dart';
import '../../domain/usecases/create_trip_usecase.dart';
import '../../domain/usecases/get_trips_usecase.dart';
import 'trip_state.dart';

final tripViewModelProvider = StateNotifierProvider<TripViewModel, TripState>((ref) {
  return TripViewModel(
    createTripUseCase: GetIt.I<CreateTripUseCase>(),
    getTripsUseCase: GetIt.I<GetTripsUseCase>(),
  );
});

class TripViewModel extends StateNotifier<TripState> {
  final CreateTripUseCase createTripUseCase;
  final GetTripsUseCase getTripsUseCase;

  TripViewModel({
    required this.createTripUseCase,
    required this.getTripsUseCase,
  }) : super(const TripState());

  Future<void> loadTrips(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final trips = await getTripsUseCase(userId);
      state = state.copyWith(trips: trips, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> createTrip({
    required String userId,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required String description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final trip = Trip(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        name: name,
        startDate: startDate,
        endDate: endDate,
        description: description,
        createdAt: DateTime.now(),
      );
      
      final createdTrip = await createTripUseCase(trip);
      state = state.copyWith(
        trips: [...state.trips, createdTrip],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void selectTrip(Trip trip) {
    state = state.copyWith(selectedTrip: trip);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}