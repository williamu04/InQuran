import 'package:inquran/services/geocode.dart';
import 'package:inquran/state/location.dart';
import 'package:inquran/state/stateful_viewmodel.dart';

class LocationViewModel extends StatefulViewModel<LocationState> {
  LocationViewModel() : super(LocationLoading());

  Future<void> loadLocation() async {
    try {
      final position = await LocationHelper.getCurrentLocation();
      final name = await LocationHelper.getPlaceName(
        position.latitude,
        position.longitude,
      );

      setState(
        LocationSuccess(
          placeName: name,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } catch (e) {
      setState(LocationError("Lokasi tidak tersedia"));
    }
  }
}