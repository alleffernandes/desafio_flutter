import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../features/work_orders/cubit/work_orders_cubit.dart';
import '../../features/work_orders/repository/work_orders_repository.dart';
import '../../service/auth_service.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:3000',
        connectTimeout: const Duration(seconds: 5),
      ),
    ),
  );

  sl.registerLazySingleton<WorkOrdersRepository>(
    () => WorkOrdersRepository(sl<Dio>()),
  );

  sl.registerLazySingleton<AuthService>(
    () => AuthService(sl<Dio>()),
  );

  sl.registerFactory<WorkOrdersCubit>(
    () => WorkOrdersCubit(repository: sl<WorkOrdersRepository>()),
  );
}
