import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:desafio_orbytis/features/inspection/repository/inspection_repository.dart';

import 'inspection_state.dart';

class InspectionCubit extends Cubit<InspectionState> {
  final InspectionRepository _repository;
  final ImagePicker _imagePicker = ImagePicker();

  InspectionCubit(this._repository) : super(const InspectionState());

  Future<void> loadDraft(int id) async {
    emit(state.copyWith(isLoading: true));
    try {
      final data = await _repository.getInspectionById(id);
      if (data != null) {
        emit(
          InspectionState(
            editingId: id,
            workOrderId: data['work_order_id'] as String?,
            observation: data['observation'] as String?,
            photoPath: data['photo_path'] as String?,
            latitude: data['latitude'] as double?,
            longitude: data['longitude'] as double?,
            isLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (photo != null) {
        emit(state.copyWith(photoPath: photo.path));
      }
    } catch (e) {}
  }

  Future<void> getLocation() async {
    emit(state.copyWith(isLoading: true));
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Os serviços de localização estão desativados.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Os serviços de localização estão desativados.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'As permissões de localização estão permanentemente negadas.',
        );
      }

      Position position = await Geolocator.getCurrentPosition().timeout(
        const Duration(seconds: 15),
      );

      emit(
        state.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> saveForm(
    String workOrderId,
    String observation,
    bool isDraft,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final data = {
        'work_order_id': workOrderId,
        'observation': observation,
        'photo_path': state.photoPath,
        'latitude': state.latitude,
        'longitude': state.longitude,
        'status': isDraft ? 'draft' : 'pending',
      };

      if (state.isEditing) {
        await _repository.updateInspection(state.editingId!, data);
      } else {
        await _repository.saveInspection(data);
      }
      emit(state.copyWith(isLoading: false, isSaved: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isSaved: false));
    }
  }
}
