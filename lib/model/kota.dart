// Widget buildFloatingSearchBarr() {
//   final isPortrait =
//       MediaQuery.of(context).orientation == Orientation.portrait;
//
//   return SearchBarAnimation(
//     textEditingController: TextEditingController(),
//     isOriginalAnimation: false,
//     trailingWidget: const Icon(
//       Icons.search,
//       size: 20,
//       color: Colors.black,
//     ),
//     secondaryButtonWidget: const Icon(
//       Icons.close,
//       size: 20,
//       color: Colors.black,
//     ),
//     buttonWidget: const Icon(
//       Icons.search,
//       size: 20,
//       color: Colors.black,
//     ),
//   );
// }

// Widget buildFloatingSearchBar() {
//   final isPortrait =
//       MediaQuery.of(context).orientation == Orientation.portrait;
//   return FloatingSearchBar(
//     controller: controller,
//     elevation: 6,
//     hintStyle: TextStyle(fontSize: 18),
//     queryStyle: TextStyle(fontSize: 18),
//     hint: 'Find a place..',
//     border: BorderSide(style: BorderStyle.none),
//     margins: EdgeInsets.fromLTRB(20, 70, 20, 0),
//     padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
//     height: 52,
//     iconColor: Colors.blue,
//     scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
//     transitionDuration: const Duration(milliseconds: 600),
//     transitionCurve: Curves.easeInOut,
//     physics: const BouncingScrollPhysics(),
//     axisAlignment: isPortrait ? 0.0 : -1.0,
//     openAxisAlignment: 0.0,
//     width: isPortrait ? 600 : 500,
//     debounceDelay: const Duration(milliseconds: 500),
//     progress: progressIndicator,
//     onQueryChanged: (query) {
//       // getPlacesSuggestions(query);
//     },
//     onFocusChanged: (_) {
//       // hide distance and time row
//       setState(() {
//         // isTimeAndDistanceVisible = false;
//       });
//     },
//     transition: CircularFloatingSearchBarTransition(),
//     actions: [
//       FloatingSearchBarAction(
//         showIfOpened: false,
//         child: CircularButton(
//             icon: Icon(Icons.place, color: Colors.black.withOpacity(0.6)),
//             onPressed: () {}),
//       ),
//     ],
//     builder: (context, transition) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // buildSuggestionsBloc(),
//             // buildSelectedPlaceLocationBloc(),
//             // buildDiretionsBloc(),
//           ],
//         ),
//       );
//     },
//   );
// }
