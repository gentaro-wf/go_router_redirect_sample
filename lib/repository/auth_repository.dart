import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  AuthRepository() {
    _user = null;
    signInController = StreamController<String?>.broadcast();
    signInController.stream.listen((user) {
      _user = user;
    });
  }

  late final StreamController<String?> signInController;
  String? _user;

  String? get currentUser => _user;
  Stream<String?> get authStateChange => signInController.stream;

  Future<void> signIn(String user) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    signInController.sink.add(user);
  }

  Future<void> signOut() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    signInController.sink.add(null);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateChangeProvider = StreamProvider<String?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChange;
});
