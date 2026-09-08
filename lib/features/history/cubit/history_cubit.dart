import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desafio_orbytis/core/database/database_service.dart';

class HistoryState {
  final bool isLoading;
  final List<Map<String, dynamic>> inspections;

  const HistoryState({this.isLoading = false, this.inspections = const []});

  HistoryState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? inspections,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      inspections: inspections ?? this.inspections,
    );
  }
}

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(const HistoryState());

  Future<void> loadHistory([String? filterStatus]) async {
    emit(state.copyWith(isLoading: true));

    try {
      final db = await DatabaseService().database;
      List<Map<String, dynamic>> result;

      if (filterStatus != null && filterStatus != 'Todos') {
        result = await db.query(
          'inspections',
          where: 'status = ?',
          whereArgs: [filterStatus],
          orderBy: 'id DESC',
        );
      } else {
        result = await db.query(
          'inspections',
          orderBy: 'id DESC',
        );
      }

      emit(state.copyWith(isLoading: false, inspections: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, inspections: []));
    }
  }
}
