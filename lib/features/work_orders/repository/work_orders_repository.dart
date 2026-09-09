import 'package:dio/dio.dart';

class WorkOrdersRepository {
  final Dio _dio;

  WorkOrdersRepository(this._dio);

  Future<List<dynamic>> fetchWorkOrders() async {
    try {
      final response = await _dio.get('/workOrders');
      if (response.data is List) {
        return response.data as List<dynamic>;
      } else if (response.data is Map && response.data.containsKey('data')) {
        return response.data['data'] as List<dynamic>;
      } else {
        return [response.data];
      }
    } catch (e) {
      throw Exception('Falha ao carregar ordens de serviço: $e');
    }
  }
}
