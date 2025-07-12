import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_view_model.dart';
import '../../../trip/presentation/providers/trip_view_model.dart';
import '../../../../core/router/router_extensions.dart';

class HomeTabPage extends ConsumerWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final tripState = ref.watch(tripViewModelProvider);
    final isLoggedIn = authState.user != null;

    // Load trips when user is logged in
    if (isLoggedIn && authState.user != null) {
      ref.listen<AuthState>(authViewModelProvider, (previous, next) {
        if (next.user != null && previous?.user == null) {
          ref.read(tripViewModelProvider.notifier).loadTrips(next.user!.id);
        }
      });
      
      // Load trips initially
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (tripState.trips.isEmpty && !tripState.isLoading) {
          ref.read(tripViewModelProvider.notifier).loadTrips(authState.user!.id);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TripPath'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '여행지 검색',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: isLoggedIn
                    ? _buildLoggedInContent(context, ref)
                    : _buildLoggedOutContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedInContent(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(tripViewModelProvider);
    
    // Show trips list if available
    if (tripState.trips.isNotEmpty) {
      return Column(
        children: [
          Expanded(
            child: _buildTripList(context, ref, tripState.trips),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.pushToCreateTrip();
              },
              icon: const Icon(Icons.add),
              label: const Text('새 여행 추가'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    // Show add trip card if no trips
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.pushToCreateTrip();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                '여행 추가하기',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '새로운 여행을 계획해보세요',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripList(BuildContext context, WidgetRef ref, List<dynamic> trips) {
    return ListView.separated(
      itemCount: trips.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _buildTripListItem(context, ref, trip);
      },
    );
  }

  Widget _buildTripListItem(BuildContext context, WidgetRef ref, dynamic trip) {
    final now = DateTime.now();
    final status = _getTripStatus(trip, now);
    final statusColor = _getStatusColor(status, context);
    final dateFormat = '${trip.startDate.month}월 ${trip.startDate.day}일 - ${trip.endDate.month}월 ${trip.endDate.day}일';
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          ref.read(tripViewModelProvider.notifier).selectTrip(trip);
          context.pushToTripDetail(trip.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTripStatus(dynamic trip, DateTime now) {
    if (now.isBefore(trip.startDate)) {
      return '예정';
    } else if (now.isAfter(trip.endDate)) {
      return '완료';
    } else {
      return '진행중';
    }
  }

  Color _getStatusColor(String status, BuildContext context) {
    switch (status) {
      case '예정':
        return Colors.blue;
      case '진행중':
        return Theme.of(context).primaryColor;
      case '완료':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLoggedOutContent(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.goToLogin();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.login,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                '로그인',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '로그인하고 여행을 계획해보세요',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}