import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/trip.dart';

part 'trip_state.freezed.dart';

@freezed
class TripState with _$TripState {
  const factory TripState({
    @Default([]) List<Trip> trips,
    @Default(false) bool isLoading,
    String? error,
    Trip? selectedTrip,
  }) = _TripState;
}