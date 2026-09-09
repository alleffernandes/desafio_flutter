import 'package:desafio_orbytis/core/database/database_service.dart';

class InspectionRepository {
  final DatabaseService _databaseService;

  InspectionRepository(this._databaseService);

  Future<int> saveInspection(Map<String, dynamic> data) async {
    return await _databaseService.insert(data);
  }

  Future<Map<String, dynamic>?> getInspectionById(int id) async {
    return await _databaseService.getInspectionById(id);
  }

  Future<int> updateInspection(int id, Map<String, dynamic> data) async {
    return await _databaseService.updateInspection(id, data);
  }

  Future<int> deleteInspection(int id) async {
    return await _databaseService.deleteInspection(id);
  }
}
