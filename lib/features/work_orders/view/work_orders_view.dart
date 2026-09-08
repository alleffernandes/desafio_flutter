import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/work_orders_cubit.dart';
import '../cubit/work_orders_state.dart';

class WorkOrdersView extends StatelessWidget {
  const WorkOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Histórico',
            onPressed: () {
              context.push('/history');
            },
            icon: const Icon(Icons.history),
          ),
        ],
        title: const Text('Ordens de Serviço'),
      ),
      body: BlocBuilder<WorkOrdersCubit, WorkOrdersState>(
        builder: (context, state) {
          if (state is WorkOrdersInitial || state is WorkOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WorkOrdersError) {
            return Center(
              child: Text(
                'Erro: ${state.message}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is WorkOrdersLoaded) {
            final orders = state.workOrders;

            if (orders.isEmpty) {
              return const Center(
                child: Text('Nenhuma ordem de serviço encontrada.'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<WorkOrdersCubit>().fetchWorkOrders();
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: orders.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final order = orders[index];

                  final id = order['id'] ?? order['_id'] ?? '?';
                  final title = order['title'] ?? order['name'] ?? 'Ordem #$id';
                  final description =
                      order['description'] ??
                      order['details'] ??
                      'Sem descrição';

                  return ListTile(
                    title: Text(title.toString()),
                    subtitle: Text(description.toString()),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      final id = order['id'].toString();
                      context.push('/inspection/$id');
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
