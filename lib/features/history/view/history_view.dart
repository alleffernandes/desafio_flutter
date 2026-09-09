import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/history_cubit.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryView> {
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().loadHistory();
  }

  void _onFilterChanged(String? newFilter) {
    setState(() {
      _selectedFilter = newFilter;
    });
    context.read<HistoryCubit>().loadHistory(newFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Inspeções'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilters(),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.inspections.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma inspeção encontrada.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.inspections.length,
                  itemBuilder: (context, index) {
                    final inspection = state.inspections[index];
                    return _InspectionCard(inspection: inspection);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          _buildFilterChip('Todos', null),
          const SizedBox(width: 8),
          _buildFilterChip('Rascunhos', 'draft'),
          const SizedBox(width: 8),
          _buildFilterChip('Pendentes', 'pending'),
          const SizedBox(width: 8),
          _buildFilterChip('Sincronizados', 'synced'),
          const SizedBox(width: 8),
          _buildFilterChip('Falhas', 'failed'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? status) {
    final isSelected = _selectedFilter == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _onFilterChanged(status);
        }
      },
    );
  }
}

class _InspectionCard extends StatelessWidget {
  final Map<String, dynamic> inspection;

  const _InspectionCard({required this.inspection});

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir Rascunho'),
        content: const Text(
          'Tem certeza que deseja excluir este rascunho? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<HistoryCubit>().deleteInspection(id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = inspection['status'] as String? ?? '';
    final workOrderId = inspection['work_order_id'] as String? ?? 'Sem ID';
    final observation = inspection['observation'] as String? ?? '';
    final errorMessage = inspection['sync_error_message'] as String?;

    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    switch (status) {
      case 'draft':
        statusColor = Colors.grey.shade600;
        statusIcon = Icons.edit_document;
        statusLabel = 'Rascunho';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        statusLabel = 'Pendente';
        break;
      case 'synced':
        statusColor = Colors.green;
        statusIcon = Icons.cloud_done;
        statusLabel = 'Sincronizado';
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusLabel = 'Falha';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
        statusLabel = 'Desconhecido';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest
          .withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'OS: $workOrderId',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              observation.isEmpty
                  ? 'Nenhuma observação informada.'
                  : observation,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (status == 'draft') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final id = inspection['id'] as int;
                        context.push('/inspection/edit/$id');
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Editar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _confirmDelete(context, inspection['id'] as int);
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Excluir'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (status == 'failed') ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Theme.of(context).colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage ??
                                'Falha desconhecida ao tentar sincronizar.',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          print(
                            'Tentar Novamente clicado para OS: $workOrderId',
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tentar Novamente'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onError,
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
