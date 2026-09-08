import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/work_orders_cubit.dart';
import '../cubit/work_orders_state.dart';

class WorkOrdersScreen extends StatelessWidget {
  const WorkOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordens de Serviço'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implementar logout através do AuthCubit futuramente
            },
          ),
        ],
      ),
      body: BlocBuilder<WorkOrdersCubit, WorkOrdersState>(
        builder: (context, state) {
          if (state is WorkOrdersInitial || state is WorkOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkOrdersError) {
            return Center(child: Text('Erro: ${state.message}'));
          } else if (state is WorkOrdersLoaded) {
            final orders = state.workOrders;
            
            if (orders.isEmpty) {
              return const Center(child: Text('Nenhuma ordem de serviço encontrada.'));
            }

            return RefreshIndicator(
              onRefresh: () => context.read<WorkOrdersCubit>().fetchWorkOrders(),
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.build)),
                    title: Text(order['title'] ?? 'Sem título'),
                    subtitle: Text('${order['status']} - ${order['date']}'),
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
