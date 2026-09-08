import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:desafio_orbytis/features/inspection/repository/inspection_repository.dart';

import 'inspection_state.dart';

class InspectionCubit extends Cubit<InspectionState> {
  final InspectionRepository _repository;
  final ImagePicker _imagePicker = ImagePicker();

  InspectionCubit(this._repository) : super(const InspectionState());

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
      Position position = await Geolocator.getCurrentPosition();
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

      await _repository.saveInspection(data);
      emit(state.copyWith(isLoading: false, isSaved: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isSaved: false));
    }
  }
}
