import 'package:flutter/material.dart';
import 'models.dart';
import 'MenuDrawer.dart';
import 'bike_list_view.dart';
import 'Maps/googlemaps.dart';

// information/instructions: Renders a detail view of an individual
// bike, using data from a Bike(). The view is structured as a Column().
// the first element is BikeDetailTopRow() (see below). Then heading "notes",
// spacer element, and NoteList().
// @params: Bike()
// @return: A page showing all the details about the Bike object.
// bugs: no known bugs
// TODO:
// 1. Include the rest of the data about the bike.
// 2. Caculate and display bike's distance from user.
// 3. Style
class BikeDetailView extends StatelessWidget {
  final Bike bikeData;
  const BikeDetailView({Key? key, required this.bikeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bike Details'),
          leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.map,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapsView()),
                );
                debugPrint('Find Bike Near Me Clicked');
              },
            )
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
              bikeData: bikeData,
            )
          ],
        ));
  }
}

// information/instructions: Display the top row of bikeDetailView.
// The first element is the bike image. Second element is a Column()
// within the row that shows details about the bike.
// @params: Bike()
// @return: Rendered view of Bike Details
// bugs: no known bugs
// TODO:
// 1. Add more data
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
    String bikeNameString = bikeData.getName();
    num bikeRating = bikeData.getRating();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.network(bikeImageUrl, width: 100, fit: BoxFit.cover),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [Text(bikeNameString), RatingStars(rating: bikeRating)],
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
// TODO:
// 1. The Note widget may add some things, like date, author, and
// style, at which point this will need to be updated.
// 2.
// 3.
class NoteList extends StatelessWidget {
  final Bike bikeData;
  const NoteList({Key? key, required this.bikeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
          child: SizedBox(
            child: ListView.builder(
              itemCount: bikeData.notes.length,
              itemBuilder: (context,i) {
                return NoteTile(note: bikeData.notes[i]);
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
// TODO:
// 1. Create a Note model that contains the text, author, date.
// right now it's just a String, but probably will need more detail
// than that.
// 2.
// 3.
class NoteTile extends StatelessWidget {
  final String note;
  const NoteTile({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(note);
  }
}
