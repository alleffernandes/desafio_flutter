import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/work_orders_repository.dart';
import 'work_orders_state.dart';

class WorkOrdersCubit extends Cubit<WorkOrdersState> {
  final WorkOrdersRepository _repository;

  WorkOrdersCubit({required WorkOrdersRepository repository})
    : _repository = repository,
      super(WorkOrdersInitial());

  Future<void> fetchWorkOrders() async {
    emit(WorkOrdersLoading());
    try {
      final data = await _repository.fetchWorkOrders();

      final List<Map<String, dynamic>> mappedData = data.map((item) {
        if (item is Map) {
          return Map<String, dynamic>.from(item);
        }
        return {'value': item.toString()};
      }).toList();

      emit(WorkOrdersLoaded(mappedData));
    } catch (e) {
      emit(WorkOrdersError(e.toString()));
    }
  }
}
