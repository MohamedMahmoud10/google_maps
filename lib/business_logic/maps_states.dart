import '../model/loctaion_details.dart';

abstract class MapsStates {}

class MapsInitial extends MapsStates {}

// class PlacesLoaded extends MapsStates {
//   final List<PlaceSuggestion> places;
//   PlacesLoaded(this.places);
// }
//
class MapsLoadingState extends MapsStates {}

class MapsSuccessState extends MapsStates {}

class MapsFailState extends MapsStates {
  final String error;

  MapsFailState({required this.error});
}

//====================================================================================================================
class LocationLoadingState extends MapsStates {}

class LocationSuccessState extends MapsStates {
  // final LocationDetails locationDetails;

  // LocationSuccessState({required this.locationDetails});
}

class LocationFailState extends MapsStates {
  final String error;

  LocationFailState({required this.error});
}

//================================================================================================================
class PlaceDirectionsLoadingState extends MapsStates {}

class PlaceDirectionsSuccessState extends MapsStates {}

class PlaceDirectionsFailState extends MapsStates {
  final String error;

  PlaceDirectionsFailState({required this.error});
}
