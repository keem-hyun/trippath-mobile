import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_view_model.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    
    ref.listen<AuthState>(
      authViewModelProvider,
      (previous, next) {
        if (next.user == null) {
          context.go('/login');
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('계정'),
        automaticallyImplyLeading: false,
      ),
      body: authState.user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: authState.user!.profileImageUrl != null
                            ? NetworkImage(authState.user!.profileImageUrl!)
                            : null,
                        child: authState.user!.profileImageUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(authState.user!.name),
                      subtitle: Text(authState.user!.email),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('로그아웃'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('로그아웃'),
                          content: const Text('정말 로그아웃하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ref.read(authViewModelProvider.notifier).signOut();
                              },
                              child: const Text('로그아웃'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}