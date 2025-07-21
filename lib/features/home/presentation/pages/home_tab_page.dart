import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_view_model.dart';
import '../../../trip/presentation/providers/trip_view_model.dart';
import '../../../../core/router/router_extensions.dart';
import '../../../../core/design_system/design_system.dart';

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
          ref
              .read(tripViewModelProvider.notifier)
              .loadTrips(authState.user!.id);
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
          Expanded(child: _buildTripList(context, ref, tripState.trips)),
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

    // Show create trip card if no trips for logged in users
    return Container(
      width: double.infinity,
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '어디로 떠나볼까요?',
            style: AppTypography.headingXL.copyWith(
              fontWeight: AppTypography.semiBold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '아직 등록된 여행이 없어요.\n나만의 여행 일정을 만들어보세요.',
            style: AppTypography.paragraphM.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.pushToCreateTrip();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '여행 추가하기',
                style: AppTypography.labelM.copyWith(
                  color: AppColors.white,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripList(BuildContext context,
      WidgetRef ref,
      List<dynamic> trips,) {
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
    final dateFormat =
        '${trip.startDate.month}월 ${trip.startDate.day}일 - ${trip.endDate
        .month}월 ${trip.endDate.day}일';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat,
                      style: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
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
              const Icon(Icons.chevron_right, color: Colors.grey),
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
        return Theme
            .of(context)
            .primaryColor;
      case '완료':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLoggedOutContent(BuildContext context) {
    final today = DateTime.now();
    final endDate = today.add(const Duration(days: 7));
    final dateFormat =
        '${today.month}월 ${today.day}일 - ${endDate.month}월 ${endDate.day}일';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 여행',
          style: AppTypography.headingXXL.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
        const Text(
          '여행 중',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 358,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                _showLoginBottomSheet(context);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1518235506717-e1ed3306a89b?w=800&h=1200&fit=crop',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7)
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '뉴욕에서 보낸 추억',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateFormat,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '뉴욕',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              _showLoginBottomSheet(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '예정된 여행',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLoginBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(
              Icons.login,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              '로그인이 필요합니다',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '여행을 계획하려면 로그인이 필요해요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.goToLogin();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('로그인하기'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('나중에'),
            ),
          ],
        ),
      ),
    );
  }
}
