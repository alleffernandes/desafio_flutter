import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class WorkOrdersListPage extends StatefulWidget {
  const WorkOrdersListPage({super.key});

  @override
  State<WorkOrdersListPage> createState() => _WorkOrdersListPageState();
}

class _WorkOrdersListPageState extends State<WorkOrdersListPage> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
      connectTimeout: const Duration(seconds: 5),
    ),
  );

  late Future<List<dynamic>> _workOrdersFuture;

  @override
  void initState() {
    super.initState();
    _workOrdersFuture = _fetchWorkOrders();
  }

  Future<List<dynamic>> _fetchWorkOrders() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordens de Serviço'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _workOrdersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          final orders = snapshot.data;
          if (orders == null || orders.isEmpty) {
            return const Center(child: Text('Nenhuma ordem de serviço encontrada.'));
          }

          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final order = orders[index];
              
              if (order is Map) {
                final id = order['id'] ?? order['_id'] ?? '?';
                final title = order['title'] ?? order['name'] ?? 'Ordem #$id';
                final description = order['description'] ?? order['details'] ?? 'Sem descrição';
                
                return ListTile(
                  title: Text(title.toString()),
                  subtitle: Text(description.toString()),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                );
              } else {
                return ListTile(
                  title: Text(order.toString()),
                );
              }
            },
          );
        },
      ),
    );
  }
}
