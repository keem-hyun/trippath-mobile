import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import '../../domain/models/schedule.dart';
import '../../domain/usecases/create_schedule_usecase.dart';
import '../../domain/usecases/get_schedule_usecase.dart';

part 'schedule_view_model.freezed.dart';

@freezed
class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    @Default([]) List<Schedule> schedules,
    @Default(false) bool isLoading,
    String? error,
  }) = _ScheduleState;
}

class ScheduleViewModel extends StateNotifier<ScheduleState> {
  final CreateScheduleUseCase _createScheduleUseCase;
  final GetScheduleUseCase _getScheduleUseCase;

  ScheduleViewModel(
    this._createScheduleUseCase,
    this._getScheduleUseCase,
  ) : super(const ScheduleState());

  Future<void> loadSchedules(String tripId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _getScheduleUseCase(tripId);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (schedules) => state = state.copyWith(
        isLoading: false,
        schedules: schedules,
      ),
    );
  }

  Future<void> createSchedule(Schedule schedule) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _createScheduleUseCase(schedule);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.toString(),
        );
        throw failure;
      },
      (createdSchedule) {
        state = state.copyWith(
          isLoading: false,
          schedules: [...state.schedules, createdSchedule],
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final scheduleViewModelProvider = StateNotifierProvider<ScheduleViewModel, ScheduleState>((ref) {
  return ScheduleViewModel(
    GetIt.I<CreateScheduleUseCase>(),
    GetIt.I<GetScheduleUseCase>(),
  );
});