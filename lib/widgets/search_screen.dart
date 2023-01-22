import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/business_logic/maps_states.dart';
import 'package:google_maps/widgets/palce_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../business_logic/maps_cubit.dart';
import '../model/loctaion_details.dart';
import '../model/maps_model.dart';
import 'email_fonm_field.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Predictions predictions;
  TextEditingController searchController = TextEditingController();
  Set<Marker> markers = {};
  late Marker searcedPlaceMarker;
  late Marker currentLocationMarker;
  static Position? position;
  late CameraPosition goToSeacredForPlaces;
  late LocationDetails locationDetails;

  // FloatingSearchBarController controller = FloatingSearchBarController();
  final Completer<GoogleMapController> _mapController = Completer();

  void buildNewCameraPosition() {
    goToSeacredForPlaces = CameraPosition(
        target: LatLng(locationDetails.result!.geometry!.location!.lat!,
            locationDetails.result!.geometry!.location!.lng!),
        bearing: 0.0,
        tilt: 0.0,
        zoom: 13);
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
            return ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    predictions = cubit.googleMapData!.predictions![index];
                    searchController.clear();
                    getSelectedPalceLocation();
                    Navigator.pop(context);
                    log('kook${predictions.placeId}');
                    // Navigator.of(context).pop();
                  },
                  child: PlaceItem(
                    predictions: cubit.googleMapData!.predictions![index],
                  ),
                );
              },
              itemCount: cubit.googleMapData!.predictions!.length,
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
        }
      },
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          EmailFormField(
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
          ),
          buildSuggestionsBloc(),
          buildSelectedLocationPlace()
        ],
      ),
    );
  }
}

// ListView buildListView(MapsCubit maps) {
//   return ListView.builder(
//     shrinkWrap: true,
//     physics: const ClampingScrollPhysics(),
//     itemBuilder: (context, index) {
//       return InkWell(
//         onTap: () {},
//         child: PlaceItem(
//           predictions: maps.googleMapData!.predictions![index],
//         ),
//       );
//     },
//     itemCount: maps.googleMapData!.predictions!.length,
//   );
// }
