import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:the_bike_kollective/models.dart';

// information/instructions: build of the modal bottom to display
// bike information
// @params: bike data
// @return: none
// bugs: none
// TODO: none
class BikeTrackDialog extends StatelessWidget {
  final Bike bikeData;
  final VoidCallback onTrack;

  BikeTrackDialog({required this.bikeData, required this.onTrack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          ExtendedImage.network(
            bikeData.imageUrl,
            width: 200,
            height: 200,
            cache: true,
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(bikeData.name),
                  Row(
                    children: [
                      Icon(Icons.star,
                          color: Colors.blueAccent),
                      Text(bikeData.rating.toString(),
                          style: TextStyle(
                              color: Colors.blueGrey,
                              // fontSize: 32.sp,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                    onPressed: onTrack,
                    style: ElevatedButton.styleFrom(elevation: 0),
                    child: Text("Take me to the bike"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
