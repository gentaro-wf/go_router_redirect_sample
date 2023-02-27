import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_redirect/repository/auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeController = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.goNamed('detail');
              },
              child: const Text('Move Detail Screen'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: homeController.isLoading
                  ? null
                  : () async {
                      final homeController =
                          ref.read(homeControllerProvider.notifier);
                      await homeController.signOut();
                    },
              child: homeController.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signOut() async {
    state = const AsyncLoading();
    final authRepository = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}

final homeControllerProvider =
    AsyncNotifierProvider.autoDispose<HomeController, void>(() {
  return HomeController();
});
