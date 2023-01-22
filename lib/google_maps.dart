// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapSample extends StatefulWidget {
//   const MapSample({Key? key}) : super(key: key);
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/model/place_directions.dart';
import 'package:google_maps/widgets/email_fonm_field.dart';
import 'package:google_maps/widgets/palce_item.dart';
import 'package:google_maps/widgets/search_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import 'business_logic/maps_cubit.dart';
import 'business_logic/maps_states.dart';
import 'helper.dart';
import 'model/loctaion_details.dart';
import 'model/maps_model.dart';

class FlutterMapsTest extends StatefulWidget {
  const FlutterMapsTest({Key? key}) : super(key: key);

  @override
  State<FlutterMapsTest> createState() => _FlutterMapsTestState();
}

class _FlutterMapsTestState extends State<FlutterMapsTest> {
  static Position? position;
  TextEditingController searchController = TextEditingController();

  // FloatingSearchBarController controller = FloatingSearchBarController();
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> markers = {};
  late Marker searcedPlaceMarker;
  late Marker currentLocationMarker;
  late CameraPosition goToSeacredForPlaces;
  late LocationDetails locationDetails;
  late Predictions predictions;

  // List<Predictions> predictionsList = [];
//NEW VARIBALES
  PlaceDirections? placeDirections;
  // var progressIndicator = false;
  late List<LatLng> polylinePoints;
  var isSearchedPlaceMarkerClicked = false;
  var isTimeAndDistanceVisible = false;
  // late String distance;
  // late String duration;

  //Hi I AM MOHAMED MAHMOUD SOFTWARE ENGINEER

  void buildNewCameraPosition() {
    goToSeacredForPlaces = CameraPosition(
        target: LatLng(locationDetails.result!.geometry!.location!.lat!,
            locationDetails.result!.geometry!.location!.lng!),
        bearing: 0.0,
        tilt: 0.0,
        zoom: 13);
  }

  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(
      position!.latitude,
      position!.longitude,
    ),
    tilt: 0.0,
    zoom: 14,
  );

  Widget buildMap() {
    return GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition: _myCurrentLocationCameraPosition,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        polylines: placeDirections != null
            ? {
                Polyline(
                    polylineId: const PolylineId('Hi'),
                    color: Colors.lightBlue,
                    width: 5,
                    points: polylinePoints)
              }
            : {});
  }

  Future<void> getMyCurrentLocation() async {
    await Geolocator.getCurrentPosition();
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  void getSelectedPalceLocation() {
    final sessiontoken = const Uuid().v4();
    BlocProvider.of<MapsCubit>(context).getLocationDetails(
        placeId: predictions.placeId!, sessiontoken: sessiontoken);
  }

  Widget buildSelectedLocationPlace() {
    return BlocListener<MapsCubit, MapsStates>(
      listener: (context, state) {
        var cubit = MapsCubit.get(context);
        if (state is LocationSuccessState) {
          locationDetails = cubit.locationDetails!;
          goToMySearcedForLocation();
          getDirections();
        }
      },
      child: Container(),
    );
  }

  void getDirections() {
    BlocProvider.of<MapsCubit>(context).getPlaceDirections(
        origin: LatLng(position!.latitude, position!.longitude),
        destination: LatLng(locationDetails.result!.geometry!.location!.lat!,
            locationDetails.result!.geometry!.location!.lng!));
  }

  Widget buildDirectionsBloc() {
    return BlocListener<MapsCubit, MapsStates>(
      listener: (context, state) {
        var cubit = MapsCubit.get(context);
        if (state is PlaceDirectionsSuccessState) {
          placeDirections = cubit.placeDirections;
          getPolylinePoints();
        }
      },
      child: Container(),
    );
  }

  void getPolylinePoints() {
    polylinePoints = placeDirections!.polyLinePoints
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
  }

  Future<void> goToMySearcedForLocation() async {
    buildNewCameraPosition();
    final GoogleMapController newController = await _mapController.future;
    newController
        .animateCamera(CameraUpdate.newCameraPosition(goToSeacredForPlaces));
    buildSearchPalceMarker();
  }

  void buildSearchPalceMarker() {
    searcedPlaceMarker = Marker(
      markerId: const MarkerId('1'),
      position: goToSeacredForPlaces.target,
      onTap: () {
        buildCurrentLocationMarker();
        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isTimeAndDistanceVisible = true;
        });
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: predictions.description!.toString()),
    );
    addMarkerToMarkerAndUpdateUi(searcedPlaceMarker);
  }

  void buildCurrentLocationMarker() {
    currentLocationMarker = Marker(
      markerId: const MarkerId('2'),
      position: LatLng(position!.latitude, position!.longitude),
      infoWindow: const InfoWindow(title: 'This Is Your Current Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkerAndUpdateUi(currentLocationMarker);
  }

  void addMarkerToMarkerAndUpdateUi(Marker marker) {
    setState(() {
      markers.add(marker);
    });
  }

  Widget buildSuggestionsBloc() {
    return BlocBuilder<MapsCubit, MapsStates>(
      builder: (context, state) {
        var cubit = MapsCubit.get(context);
        if (state is MapsSuccessState) {
          if (cubit.googleMapData!.predictions!.isNotEmpty) {
            return SizedBox(
              height: 250,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      predictions = cubit.googleMapData!.predictions![index];
                      searchController.clear();
                      getSelectedPalceLocation();
                      polylinePoints.clear();
                      log('kook${predictions.placeId}');
                      // Navigator.of(context).pop();
                    },
                    child: PlaceItem(
                      predictions: cubit.googleMapData!.predictions![index],
                    ),
                  );
                },
                itemCount: cubit.googleMapData!.predictions!.length,
              ),
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  // void getPlacesSuggestions(String pattern) {
  //   final sessionToken = const Uuid().v4();
  //   BlocProvider.of<MapsCubit>(context)
  //       .getMapResult(inPut: pattern, sessiontoken: sessionToken);
  // }

  // Widget buildSearchBarr() {
  //   return SizedBox(
  //     width: 250,
  //     child: TypeAheadField(
  //       textFieldConfiguration: TextFieldConfiguration(
  //           controller: searchController,
  //           autofocus: true,
  //           style: DefaultTextStyle.of(context)
  //               .style
  //               .copyWith(fontStyle: FontStyle.italic),
  //           decoration: const InputDecoration(border: OutlineInputBorder())),
  //       suggestionsCallback: (pattern) {
  //         final sessionToken = const Uuid().v4();
  //
  //         return BlocProvider.of<MapsCubit>(context)
  //             .getMapResult(inPut: pattern, sessiontoken: sessionToken);
  //       },
  //       itemBuilder: (context, suggestion) {
  //         return ListView(
  //           children: [buildSuggestionsBloc(), buildSelectedLocationPlace()],
  //         );
  //       },
  //       onSuggestionSelected: (Object? suggestion) {},
  //       // onSuggestionSelected: (suggestion) {
  //       //   Navigator.of(context).push(MaterialPageRoute(
  //       //       builder: (context) => ProductPage(product: suggestion)
  //       //   ));
  //       // },
  //     ),
  //   );
  // }

  Widget buildSearchBar() {
    return EmailFormField(
      hitText: 'Search',
      label: 'Search SomeThing',
      prefixIcon: const Icon(Icons.search),
      emailController: searchController,
      onChanged: (String? value) {
        String sessionToken = const Uuid().v4();
        BlocProvider.of<MapsCubit>(context)
            .getMapResult(inPut: value!, sessiontoken: sessionToken);
      },
      validator: (String? value) {
        return null;
      },
      keyboardType: TextInputType.text,
      onFieldSubmitted: (String value) {},
    );
  }

  @override
  void initState() {
    getMyCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            position != null
                ? buildMap()
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            // buildFloatingSearchBar(),
            buildSearchBar(),
            buildSuggestionsBloc(),
            buildSelectedLocationPlace(),
            buildDirectionsBloc(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _goToMyCurrentLocation,
          child: const Icon(Icons.place),
        ),
      ),
    );
  }
}
