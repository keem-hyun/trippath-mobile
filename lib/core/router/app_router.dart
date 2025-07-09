import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/base/presentation/pages/base_page.dart';
import '../../features/auth/presentation/providers/auth_view_model.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authViewModelProvider);
  
  return GoRouter(
    initialLocation: authState.user != null ? '/home' : '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isLoginPage = state.fullPath == '/login';
      
      if (!isLoggedIn && !isLoginPage) {
        return '/login';
      }
      
      if (isLoggedIn && isLoginPage) {
        return '/home';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const BasePage(),
      ),
    ],
  );
});