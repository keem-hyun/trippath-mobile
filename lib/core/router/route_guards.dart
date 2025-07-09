import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_view_model.dart';
import 'routes.dart';

class RouteGuards {
  static String? authGuard(
    GoRouterState state,
    AuthState authState,
  ) {
    final isLoggedIn = authState.user != null;
    final isLoginPage = state.fullPath == Routes.login;
    final isSplashPage = state.fullPath == Routes.splash;

    // 초기화 중이면 스플래시 페이지로
    if (authState.isInitializing && !isSplashPage) {
      return Routes.splash;
    }

    // 초기화 완료 후 스플래시 페이지에 있으면 적절한 페이지로 이동
    // 하지만 SplashPage에서 직접 네비게이션 처리하므로 여기서는 null 반환
    if (!authState.isInitializing && isSplashPage) {
      return null; // SplashPage에서 처리
    }

    // 로그인한 사용자가 로그인 페이지에 접근하려는 경우
    if (isLoggedIn && isLoginPage) {
      return Routes.home;
    }

    // 비로그인 사용자도 홈 및 다른 페이지 접근 가능
    return null;
  }
}