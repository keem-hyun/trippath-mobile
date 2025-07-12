import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/base/presentation/pages/base_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/trip/presentation/pages/create_trip_page.dart';
import '../../features/trip/presentation/pages/trip_detail_page.dart';

abstract class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String trip = '/trip';
  static const String createTrip = '/trip/create';
  static const String tripDetail = '/trip/:id';
}

abstract class AppRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: Routes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.home,
      name: 'home',
      builder: (context, state) => const BasePage(),
    ),
    GoRoute(
      path: Routes.createTrip,
      name: 'createTrip',
      builder: (context, state) => const CreateTripPage(),
    ),
    GoRoute(
      path: Routes.tripDetail,
      name: 'tripDetail',
      builder: (context, state) {
        final tripId = state.pathParameters['id']!;
        return TripDetailPage(tripId: tripId);
      },
    ),
  ];
}