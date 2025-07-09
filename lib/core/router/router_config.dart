class RouterConfig {
  // 라우터 설정
  static const bool debugLogDiagnostics = true;
  
  // 애니메이션 지속 시간
  static const Duration transitionDuration = Duration(milliseconds: 300);
  
  // 기본 페이지 트랜지션
  static const Transition defaultTransition = Transition.fade;
  
  // 에러 페이지 경로
  static const String errorPagePath = '/error';
}

enum Transition {
  fade,
  slide,
  scale,
  none,
}