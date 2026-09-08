abstract class WorkOrdersState {}

class WorkOrdersInitial extends WorkOrdersState {}

class WorkOrdersLoading extends WorkOrdersState {}

class WorkOrdersLoaded extends WorkOrdersState {
  final List<Map<String, dynamic>> workOrders;

  WorkOrdersLoaded(this.workOrders);
}

class WorkOrdersError extends WorkOrdersState {
  final String message;

  WorkOrdersError(this.message);
}
