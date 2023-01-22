// import 'package:flutter/material.dart';
// import 'package:google_maps/model/place_directions.dart';
//
// class DistanceAndDuration extends StatelessWidget {
//   const DistanceAndDuration(
//       {Key? key,
//       required this.isDistanceAndDurationVisible,
//       this.placeDirections})
//       : super(key: key);
//   final PlaceDirections? placeDirections;
//   final bool isDistanceAndDurationVisible;
//
//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//         visible: isDistanceAndDurationVisible,
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: Row(
//             children: [
//               Flexible(
//                 flex: 1,
//                 child: Card(
//                   elevation: 6,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     dense: true,
//                     horizontalTitleGap: 0,
//                     leading: const Icon(Icons.social_distance_sharp),
//                     title: Text(
//                       placeDirections!.totalDistance,
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                   ),
//                 ),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: Card(
//                   elevation: 6,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     dense: true,
//                     horizontalTitleGap: 0,
//                     leading: const Icon(Icons.timer),
//                     title: Text(
//                       placeDirections!.totalDuration,
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
