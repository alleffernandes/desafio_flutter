import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/cubit/auth_state.dart';
import '../../features/work_orders/cubit/work_orders_cubit.dart';
import '../../features/work_orders/view/work_orders_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    initialLocation: '/login',
    redirect: (context, state) {
      final authState = authCubit.state;
      final isGoingToLogin = state.uri.path == '/login';

      if (authState is Unauthenticated && !isGoingToLogin) {
        return '/login';
      }

      if (authState is Authenticated && isGoingToLogin) {
        return '/work-orders';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Login Page - Esqueleto'))),
      ),
      GoRoute(
        path: '/work-orders',
        builder: (context, state) => BlocProvider(
          create: (context) => WorkOrdersCubit()..fetchWorkOrders(),
          child: const WorkOrdersScreen(),
        ),
      ),
    ],
  );
}
