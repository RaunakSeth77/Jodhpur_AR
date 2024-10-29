import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iitj_ram/Maps/api.dart';
import 'package:iitj_ram/Maps/directions.dart';

class Directions_Repository {
  static const String base_url =
      'https://maps.googleapis.com/maps/api/directions/json?';
  late final Dio _dio;

  Directions_Repository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    print(origin);
    final response = await _dio.get(base_url, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': GoogleAPIKey
    });

    if (response.statusCode == 200) {
      print(response.data);
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
