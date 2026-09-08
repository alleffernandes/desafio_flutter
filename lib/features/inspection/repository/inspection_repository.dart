import 'package:desafio_orbytis/core/database/database_service.dart';

class InspectionRepository {
  final DatabaseService _databaseService;

  InspectionRepository(this._databaseService);

  Future<int> saveInspection(Map<String, dynamic> data) async {
    return await _databaseService.insert(data);
  }
}
