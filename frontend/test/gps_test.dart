import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

//This is how I would test location

// Models
class LocationInput {
  final double latitude;
  final double longitude;

  LocationInput({
    required this.latitude,
    required this.longitude,
  });
}

class LocationData {
  final double speed;
  final double longitude;
  final double latitude;

  LocationData(
      {required this.speed, required this.longitude, required this.latitude});
}

// Location API
class LocationApi {
  getLocation() async {}
}

// Maps API
class IteratorSoftMapsApi {
  dynamic showLocationOnMap(LocationData data) async {
    try {
      if (data.longitude == 10.714116158980621 &&
          data.latitude == 122.5513503415961) {
        return "SM City Iloilo";
      } else if (data.longitude == 10.717484303610135 &&
          data.latitude == 122.5460816187768) {
        return "Festive Walk";
      }
    } catch (e) {
      throw e;
    }
  }
}

// Mocked API
class MockLocationApi extends Mock implements LocationApi {
  @override
  Future<LocationData> getLocation() async {
    try {
      // Place(longitude, latitude)

      // SM City(10.714116158980621, 122.5513503415961)
      return LocationData(
          longitude: 10.714116158980621, latitude: 122.5513503415961, speed: 0);

      // // Festive Walk(10.717484303610135, 122.5460816187768)
      // return LocationData(
      //   longitude: 10.714116158980621,
      //   latitude: 122.5513503415961,
      //   speed: 0
      // );
    } catch (e) {
      throw e;
    }
  }
}

void main() async {
  var location = MockLocationApi();
  var mapsApi = IteratorSoftMapsApi();

  test('Location API should be able to return location data', () async {
    var locationData = await location.getLocation();
    var expectedLocData = LocationData(
        speed: 0, longitude: 10.714116158980621, latitude: 122.5513503415961);

    expect(locationData.speed, expectedLocData.speed);
    expect(locationData.longitude, expectedLocData.longitude);
    expect(locationData.latitude, expectedLocData.latitude);
  });

    test('Maps API should be able to return the location name using location data', () async {
    var locationData = await location.getLocation();
    var place = await mapsApi.showLocationOnMap(locationData);
    expect(place, "SM City Iloilo");
  });
}
