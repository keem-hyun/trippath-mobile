import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/trip_view_model.dart';
import '../../../../core/router/router_extensions.dart';
import '../../domain/models/schedule.dart';
import 'package:intl/intl.dart';

class TripDetailPage extends ConsumerStatefulWidget {
  final String tripId;

  const TripDetailPage({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends ConsumerState<TripDetailPage> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    // Set initial selected date to trip start date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tripState = ref.read(tripViewModelProvider);
      final trip = tripState.selectedTrip;
      if (trip != null) {
        setState(() {
          selectedDate = trip.startDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripState = ref.watch(tripViewModelProvider);
    final trip = tripState.selectedTrip;

    if (trip == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text('여행 정보를 불러올 수 없습니다.'),
        ),
      );
    }

    final dateFormat = '${trip.startDate.month}월 ${trip.startDate.day}일 - ${trip.endDate.month}월 ${trip.endDate.day}일';
    selectedDate ??= trip.startDate;
    
    final selectedDateKey = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final daySchedules = trip.schedules[selectedDateKey] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () {
                          // TODO: Show more options
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    trip.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateFormat,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '설명',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildDateSelector(context, trip),
                  const SizedBox(height: 16),
                  Text(
                    '${daySchedules.length}개 항목',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: daySchedules.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '아직 계획된 일정이 없어요.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '지금 첫 일정을 추가해볼까요?',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to add schedule
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('일정 추가'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: daySchedules.length,
                        itemBuilder: (context, index) {
                          final schedule = daySchedules[index];
                          return _buildScheduleItem(context, schedule);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, dynamic trip) {
    final totalDays = trip.endDate.difference(trip.startDate).inDays + 1;
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(totalDays, (index) {
          final date = trip.startDate.add(Duration(days: index));
          final isSelected = selectedDate != null && 
              DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(selectedDate!);
          final dateKey = DateFormat('yyyy-MM-dd').format(date);
          final hasSchedules = trip.schedules.containsKey(dateKey) && trip.schedules[dateKey]!.isNotEmpty;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                });
              },
              child: Column(
                children: [
                  Text(
                    weekdays[date.weekday % 7],
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : hasSchedules
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.grey[100],
                      border: hasSchedules && !isSelected
                          ? Border.all(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : hasSchedules
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScheduleItem(BuildContext context, Schedule schedule) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  schedule.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (schedule.cost != null)
                  Text(
                    '${schedule.cost!.toStringAsFixed(0)}원',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              schedule.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (schedule.locations.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      schedule.locations.join(', '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                ],
              ),
            ],
            if (schedule.description != null) ...[
              const SizedBox(height: 8),
              Text(
                schedule.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}