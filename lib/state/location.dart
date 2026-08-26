sealed class LocationState {}

class LocationLoading extends LocationState {}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}

class LocationSuccess extends LocationState {
  final String placeName;
  final double latitude;
  final double longitude;

  LocationSuccess({
    required this.placeName,
    required this.latitude,
    required this.longitude,
  });
}