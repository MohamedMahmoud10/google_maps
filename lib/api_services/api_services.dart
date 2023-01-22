import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constans/strings/strings.dart';

class ApiServices {
  late Dio dio;

  ApiServices() {
    BaseOptions options = BaseOptions();
    dio = Dio(options);
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: print,
      ),
    );
  }

  Future getMapData(
      {required String inPut, required String sessiontoken}) async {
    return await dio.get(
      placeAutoCompleteBaseUrl,
      queryParameters: {
        'input': inPut,
        'components': 'country:eg',
        'type': 'address',
        'key': googleApiKey,
        'sessiontoken': sessiontoken
      },
    );
  }

  Future getLocationDetail(
      {required String placeId, required String sessiontoken}) async {
    try {
      return await dio.get(
        locationDetailsBaseUrl,
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': googleApiKey,
          'sessiontoken': sessiontoken
        },
      );
    } catch (e) {
      return Future.error("Place location error : ",
          StackTrace.fromString(('this is its trace')));
    }
  }

  Future getPlaceDirections(
      {required LatLng origin, required LatLng destination}) async {
    try {
      return await dio.get(
        placeDirectionsBaseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': googleApiKey,
        },
      );
    } catch (e) {
      return Future.error("Place location error : ",
          StackTrace.fromString(('this is its trace')));
    }
  }
}
