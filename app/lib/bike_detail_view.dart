import 'package:flutter/material.dart';
import 'package:the_bike_kollective/Maps/maps_from_list.dart';
//import 'package:the_bike_kollective/global_values.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:the_bike_kollective/requests.dart';
import 'models.dart';
import 'MenuDrawer.dart';
import 'style.dart';
import 'requests.dart';
import 'profile_view.dart';
import 'package:the_bike_kollective/Maps/mapwidgets/bike_modal_bottom.dart';


// information/instructions: Renders a detail view of an individual
// bike, using data from a Bike(). The view is structured as a Column().
// the first element is BikeDetailTopRow() (see below). Then heading "notes",
// spacer element, and NoteList().
// @params: Bike()
// @return: A page showing all the details about the Bike object.
// bugs: no known bugs
class BikeDetailView extends StatelessWidget {
  final Bike bikeData;
  const BikeDetailView({Key? key, required this.bikeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bike Details'),
          leading: (ModalRoute.of(context)?.canPop ?? false) ? const BackButton() : null,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.alt_route_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                //_openBikeInfoDialog(bikeData);
                  final result = showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    // isScrollControlled: true,
                    builder: (_) {
                      return BikeTrackDialog(
                        bikeData: bikeData,
                        onTrack: () {
                          print("IN ON TRACK");
                          // print(bikeData.lockCombination);
                          print("BIKE DATWA");
                          print(bikeData.name);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapsViewFromList(
                                    destinationBike: bikeData)),
                          );
                        },
                      );
              },
            );
            })
          ],
        ),
        endDrawer: const MenuDrawer(),
        body: Column(
          children: [
            BikeDetailTopRow(bikeData: bikeData),
            const SizedBox(height: 25),
            const Text(
              'Notes on This Bike',
              style: TextStyle(fontSize: 28),
            ),
            NoteList(
              notes: bikeData.getNotes(),
            )
          ],
        )
      );
  }
}

// information/instructions: Display the top row of bikeDetailView.
// The first element is the bike image. Second element is a Column()
// within the row that shows details about the bike.
// @params: Bike()
// @return: Rendered view of Bike Details
// bugs: no known bugs
// TODO:
// 2. Consider that the distance from current user may best be
// calculated within the Bike Model itself, so that it can be
// displayed wherever we need it. The BikeModel would have to
// have access to the user's location somehow for that to work.

class BikeDetailTopRow extends StatelessWidget {
  final Bike bikeData;
  const BikeDetailTopRow({Key? key, required this.bikeData}) : super(key: key);
   
  @override
  Widget build(BuildContext context) {
    String bikeImageUrl = bikeData.getImageUrl();
    String bikeNameString = 'Bike Name: "' + bikeData.getName() + '"';
    num bikeRating = bikeData.getAverageRating();
    String typeString = 'Type: ' + bikeData.getType();
    String sizeString = 'Size: ' + bikeData.getSize();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.network(bikeImageUrl, width: 100, fit: BoxFit.cover),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(bikeNameString), 
            Text(typeString),
            Text(sizeString),
            RatingBarIndicator(
              rating: bikeRating.toDouble(),
              itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 25.0,
              direction: Axis.horizontal,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: buttonStyle['backgroundColor'],
                primary: buttonStyle['textColor']
              ),
              onPressed: () async {
                debugPrint('checkout Bike button clicked');
                await checkOutBike(bikeData.getId() );
                Navigator.pushNamed(context, ProfileView.routeName);
              },
              child: const Text('Check Out'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: buttonStyle['reportBackground'],
                primary: buttonStyle['textColor']
              ),
              onPressed: () async {
                debugPrint('Report Missing button clicked');
                await reportBikeMissing(bikeData.getId() );
                Navigator.pushNamed(context, ProfileView.routeName);
              },
              child: const Text('Report Missing',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        )
      ],
    );
  }
}

// information/instructions: Renders the list of notes contained in
// the bike parameter.
// @params: Bike()
// @return: list
// bugs: no known bugs
class NoteList extends StatelessWidget {
  final List notes;
  const NoteList({Key? key, required this.notes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
          child: SizedBox(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context,i) {
                return NoteTile(note: notes[i]['note_body']);
              }
            )
          )
      )
    );
  }
}

// information/instructions: Renders an individual note from the bike
// data.
// @params: String note (note will probably need to be it's own Class)
// @return:
// bugs: no known bugs
class NoteTile extends StatelessWidget {
  final String note;
  const NoteTile({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(note);
    return Text(note);
  }
}