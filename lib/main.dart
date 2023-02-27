import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_redirect/repository/auth_repository.dart';
import 'package:go_router_redirect/screens/detail_screen.dart';
import 'package:go_router_redirect/screens/home_screen.dart';
import 'package:go_router_redirect/screens/sign_in_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Redirect Sample',
      routerConfig: appRouter,
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'detail',
            name: 'detail',
            builder: (context, state) => const DetailScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/signIn',
        name: 'signIn',
        builder: (context, state) => const SignInScreen(),
      ),
    ],
    redirect: (context, state) {
      final user = authRepository.currentUser;
      // サインインしていなければサインイン画面へリダイレクト
      if (user == null) {
        return '/signIn';
      }

      // サインインしており、サインイン画面にいるならばホーム画面へリダイレクト
      if (state.location == '/signIn') {
        return '/';
      }

      // 上記以外はリダイレクトしない
      return null;
    },
    refreshListenable: RedirectNotifier(authRepository.authStateChange),
  );
});

class RedirectNotifier extends ChangeNotifier {
  RedirectNotifier(Stream<String?> authStateChangeStream) {
    notifyListeners();
    _subscription = authStateChangeStream.listen((_) {
      // 認証の状態が変更されたら通知
      notifyListeners();
    });
  }

  late final StreamSubscription<String?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
