import 'package:flutter/material.dart';

import '../model/maps_model.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({Key? key, required this.predictions}) : super(key: key);
  final Predictions predictions;
  // final PlaceSuggestion predictions;
  @override
  Widget build(BuildContext context) {
    var subTitle = predictions.description
        ?.replaceAll(predictions.description!.split(',')[0], '');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                  color: Colors.lightBlue, shape: BoxShape.circle),
              child: const Icon(Icons.place),
            ),
            title: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text:
                      '${predictions.description.toString().split(',')[0].toString() ?? ''}\n',
                  style: const TextStyle(color: Colors.red),
                ),
                TextSpan(
                    text: subTitle!.substring(2),
                    style: TextStyle(color: Colors.black))
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
