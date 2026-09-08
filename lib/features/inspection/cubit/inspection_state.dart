class InspectionState {
  final String? photoPath;
  final double? latitude;
  final double? longitude;
  final bool isLoading;
  final bool isSaved;

  const InspectionState({
    this.photoPath,
    this.latitude,
    this.longitude,
    this.isLoading = false,
    this.isSaved = false,
  });

  InspectionState copyWith({
    String? photoPath,
    double? latitude,
    double? longitude,
    bool? isLoading,
    bool? isSaved,
  }) {
    return InspectionState(
      photoPath: photoPath ?? this.photoPath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
