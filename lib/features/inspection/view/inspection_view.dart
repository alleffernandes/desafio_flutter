import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desafio_orbytis/features/inspection/cubit/inspection_cubit.dart';
import 'package:desafio_orbytis/features/inspection/cubit/inspection_state.dart';

class InspectionView extends StatefulWidget {
  final String workOrderId;
  final int? editingId;

  const InspectionView({super.key, required this.workOrderId, this.editingId});

  @override
  State<InspectionView> createState() => _InspectionViewState();
}

class _InspectionViewState extends State<InspectionView> {
  final TextEditingController _observationController = TextEditingController();
  bool _hasLoadedDraft = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editingId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Inspeção' : 'Nova Inspeção'),
        centerTitle: true,
      ),
      body: BlocConsumer<InspectionCubit, InspectionState>(
        listener: (context, state) {
          // Pre-fill observation from loaded draft (only once)
          if (state.observation != null && !_hasLoadedDraft) {
            _observationController.text = state.observation!;
            _hasLoadedDraft = true;
          }

          if (state.isSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isEditing
                      ? 'Inspeção atualizada com sucesso!'
                      : 'Inspeção salva com sucesso!',
                ),
              ),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ordem de Serviço: ${widget.workOrderId}',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _observationController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Observação',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.read<InspectionCubit>().takePhoto(),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tirar Foto'),
                ),
                if (state.photoPath != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Foto anexada:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(state.photoPath!),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.read<InspectionCubit>().getLocation(),
                  icon: const Icon(Icons.location_on),
                  label: const Text('Obter Localização'),
                ),
                if (state.latitude != null && state.longitude != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Coordenadas obtidas:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lat: ${state.latitude}\nLon: ${state.longitude}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
                const SizedBox(height: 48),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<InspectionCubit>().saveForm(
                            widget.workOrderId,
                            _observationController.text,
                            true,
                          );
                        },
                        child: const Text('Salvar Rascunho'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          context.read<InspectionCubit>().saveForm(
                            widget.workOrderId,
                            _observationController.text,
                            false,
                          );
                        },
                        child: const Text('Concluir Inspeção'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
