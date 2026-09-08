import 'dart:async';

import 'package:desafio_orbytis/core/database/database_service.dart';
import 'package:desafio_orbytis/features/history/cubit/history_cubit.dart';
import 'package:desafio_orbytis/features/history/view/history_view.dart';
import 'package:desafio_orbytis/features/inspection/cubit/inspection_cubit.dart';
import 'package:desafio_orbytis/features/inspection/repository/inspection_repository.dart';
import 'package:desafio_orbytis/features/inspection/view/inspection_view.dart';
import 'package:desafio_orbytis/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/cubit/auth_state.dart';
import '../../features/work_orders/cubit/work_orders_cubit.dart';
import '../../features/work_orders/view/work_orders_view.dart';
import '../di/service_locator.dart';

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
      GoRoute(path: '/login', builder: (context, state) => LoginView()),
      GoRoute(
        path: '/work-orders',
        builder: (context, state) => BlocProvider(
          create: (context) => sl<WorkOrdersCubit>()..fetchWorkOrders(),
          child: const WorkOrdersView(),
        ),
      ),
      GoRoute(
        path: '/inspection/:id',
        builder: (context, state) {
          final String idDaOrdem = state.pathParameters['id']!;
          return BlocProvider(
            create: (context) =>
                InspectionCubit(InspectionRepository(DatabaseService())),
            child: InspectionView(workOrderId: idDaOrdem),
          );
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => BlocProvider(
          create: (context) => HistoryCubit()..loadHistory(),
          child: const HistoryView(),
        ),
      ),
    ],
  );
}
