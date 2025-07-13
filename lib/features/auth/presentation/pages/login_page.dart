import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/router/router_extensions.dart';
import '../../../../shared/widgets/error_dialog.dart';
import '../providers/auth_view_model.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.user != null && previous?.user == null) {
        context.goToHome();
      }

      if (next.error != null) {
        final error = next.error!;
        
        if (error.contains('Connection refused') || error.contains('network')) {
          NetworkErrorDialog.show(
            context,
            message: '서버에 연결할 수 없습니다.\n네트워크 연결을 확인해주세요.',
            onRetry: () {
              ref.read(authViewModelProvider.notifier).signInWithGoogle();
            },
          );
        } else if (error.contains('cancelled')) {
          // Google 로그인 취소는 무시
        } else {
          ErrorDialog.show(
            context,
            title: '로그인 오류',
            message: error,
          );
        }
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () {
                  context.goToHome();
                },
                child: Text(
                  '건너 뛰기',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '여행',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '그 이상을 담다.',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const Spacer(),
              if (authState.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(authViewModelProvider.notifier).signInWithGoogle();
                  },
                  icon: const Icon(Icons.login, size: 24),
                  label: const Text('Google로 로그인'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
