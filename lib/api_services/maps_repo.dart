//
// class MapsRepository {
//   final ApiServices apiServices;
//
//   MapsRepository(this.apiServices);
//
//   Future<List<PlaceSuggestion>> fetchSuggestions(
//       String place, String sessionToken) async {
//     final suggestions = await apiServices.fetchSuggestions(place, sessionToken);
//
//     return suggestions
//         .map((suggestion) =>
//             PlaceSuggestion.fromJson(suggestion as Map<String, dynamic>))
//         .toList();
//   }
// }
