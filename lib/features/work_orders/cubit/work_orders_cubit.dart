import 'package:flutter_bloc/flutter_bloc.dart';
import 'work_orders_state.dart';

class WorkOrdersCubit extends Cubit<WorkOrdersState> {
  WorkOrdersCubit() : super(WorkOrdersInitial());

  Future<void> fetchWorkOrders() async {
    emit(WorkOrdersLoading());
    try {
      // Substitua este delay pela sua chamada real do Dio
      await Future.delayed(const Duration(seconds: 1));
      
      // Dados mockados
      final mockData = [
        {'id': 1, 'title': 'Manutenção Preventiva - Ar Condicionado', 'status': 'Aberta', 'date': '2023-10-25'},
        {'id': 2, 'title': 'Troca de Lâmpadas - Setor B', 'status': 'Em andamento', 'date': '2023-10-26'},
        {'id': 3, 'title': 'Reparo Hidráulico - Banheiro 1', 'status': 'Concluída', 'date': '2023-10-24'},
      ];
      
      emit(WorkOrdersLoaded(mockData));
    } catch (e) {
      emit(WorkOrdersError(e.toString()));
    }
  }
}
