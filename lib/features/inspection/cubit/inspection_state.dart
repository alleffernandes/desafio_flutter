class InspectionState {
  final int? editingId;
  final String? workOrderId;
  final String? photoPath;
  final double? latitude;
  final double? longitude;
  final String? observation;
  final bool isLoading;
  final bool isSaved;

  const InspectionState({
    this.editingId,
    this.workOrderId,
    this.photoPath,
    this.latitude,
    this.longitude,
    this.observation,
    this.isLoading = false,
    this.isSaved = false,
  });

  bool get isEditing => editingId != null;

  InspectionState copyWith({
    int? editingId,
    String? workOrderId,
    String? photoPath,
    double? latitude,
    double? longitude,
    String? observation,
    bool? isLoading,
    bool? isSaved,
  }) {
    return InspectionState(
      editingId: editingId ?? this.editingId,
      workOrderId: workOrderId ?? this.workOrderId,
      photoPath: photoPath ?? this.photoPath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      observation: observation ?? this.observation,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
