import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/api_services/api_services.dart';
import 'package:google_maps/business_logic/maps_states.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/loctaion_details.dart';
import '../model/maps_model.dart';
import '../model/place_directions.dart';

class MapsCubit extends Cubit<MapsStates> {
  MapsCubit(this.apiServices) : super(MapsInitial());

  // final MapsRepository mapsRepository;
  GoogleMapData? googleMapData;
  ApiServices apiServices;

  static MapsCubit get(context) => BlocProvider.of(context);

  // void emitPlaceSuggestions(String place, String sessionToken) {
  //   mapsRepository.fetchSuggestions(place, sessionToken).then((suggestions) {
  //     emit(PlacesLoaded(suggestions));
  //   });
  // }
  List<Predictions> predictionsList = [];

  List<Predictions> getMapResult(
      {required String inPut, required String sessiontoken}) {
    emit(MapsLoadingState());
    apiServices
        .getMapData(inPut: inPut, sessiontoken: sessiontoken)
        .then((value) {
      googleMapData = GoogleMapData.fromJson(value.data);
      predictionsList = googleMapData!.predictions!;
      log(value.data.toString());
      emit(MapsSuccessState());
    }).catchError((error) {
      log(error.toString());
      emit(MapsFailState(error: error.toString()));
      return [];
    });
    return predictionsList;
  }

  //=================================================================================================================================
  LocationDetails? locationDetails;

  void getLocationDetails({required String placeId, required sessiontoken}) {
    emit(LocationLoadingState());
    apiServices
        .getLocationDetail(placeId: placeId, sessiontoken: sessiontoken)
        .then((value) {
      locationDetails = LocationDetails.fromJson(value.data);
      log('The Data Is ${value.data}');
      emit(LocationSuccessState());
    }).catchError((error) {
      log('The Error Is $error');
      emit(LocationFailState(error: error.toString()));
    });
  }

  //=======================================================================================================================
    PlaceDirections?placeDirections;

 void  getPlaceDirections(
      {required LatLng origin, required LatLng destination}) {
    emit(PlaceDirectionsLoadingState());
    apiServices
        .getPlaceDirections(origin: origin, destination: destination)
        .then((value) {
      placeDirections = PlaceDirections.fromJson(value.data);
      log('PlaceDirections is ${value.data}');
      emit(PlaceDirectionsSuccessState());
      // return placeDirections!;
    }).catchError((error) {
      log(error.toString());
      emit(PlaceDirectionsFailState(error: error.toString()));
    });
 }
}
