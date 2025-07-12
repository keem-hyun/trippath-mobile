import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/trip_view_model.dart';
import '../../../../core/router/router_extensions.dart';

class TripDetailPage extends ConsumerWidget {
  final String tripId;

  const TripDetailPage({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    '여행 기간',
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
                    '0개 항목',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Center(
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
    final today = DateTime.now();
    final currentDay = today.difference(trip.startDate).inDays + 1;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(7, (index) {
          final date = today.add(Duration(days: index - 3));
          final dayNumber = date.difference(trip.startDate).inDays + 1;
          final isInTrip = date.isAfter(trip.startDate.subtract(const Duration(days: 1))) &&
              date.isBefore(trip.endDate.add(const Duration(days: 1)));
          final isToday = index == 3;
          final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Text(
                  weekdays[date.weekday % 7],
                  style: TextStyle(
                    fontSize: 12,
                    color: isToday ? Theme.of(context).primaryColor : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isInTrip
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.grey[100],
                    border: isToday
                        ? Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        color: isInTrip ? Theme.of(context).primaryColor : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}