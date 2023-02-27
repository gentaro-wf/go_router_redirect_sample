import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router_redirect/repository/auth_repository.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInInController = ref.watch(signInControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: signInInController.isLoading
              ? null
              : () async {
                  final signInInController =
                      ref.read(signInControllerProvider.notifier);
                  await signInInController.signIn('user');
                },
          child: signInInController.isLoading
              ? const CircularProgressIndicator()
              : const Text('Sign In'),
        ),
      ),
    );
  }
}

class SignInController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signIn(String user) async {
    state = const AsyncLoading();
    final authRepository = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() => authRepository.signIn(user));
  }
}

final signInControllerProvider =
    AsyncNotifierProvider.autoDispose<SignInController, void>(() {
  return SignInController();
});
