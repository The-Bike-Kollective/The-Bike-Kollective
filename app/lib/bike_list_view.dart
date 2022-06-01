import 'package:flutter/material.dart';
import 'package:the_bike_kollective/get-photo.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'models.dart';
import 'MenuDrawer.dart';
import 'bike_detail_view.dart';
import 'Maps/googlemaps.dart';
import 'requests.dart';
import 'style.dart';

// information/instructions: Renders the bike list from the
// BikeListModel object's data.
// @params: BikeListModel
// @return:
// bugs: no known bugs
class BikeListView extends StatefulWidget {
  const BikeListView({Key? key}) : super(key: key);
  static const routeName = '/bike-list';
  @override
  State<BikeListView> createState() => _BikeListViewState();
}


// These values are used for the radio buttons.
enum Size {none, small, medium, large}
enum Type {none, road, mountain}
// This is the state object that is called by BikeListView().
class _BikeListViewState extends State<BikeListView> {
  String buttonToolTipText = "add a bike";
  Future<BikeListModel> currentList = getBikeList();
  String size = "";
  String type = "";
  Size? _size = Size.none;
  Type? _type = Type.none;
  Map tags = {'size': '', 'type': ''};
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (ModalRoute.of(context)?.canPop ?? false) ? const BackButton() : null,
        title: FutureBuilder(
          future: currentList,
          builder: (context, AsyncSnapshot<BikeListModel> snapshot) {
            if (snapshot.hasData) {
              int numBikes = snapshot.data!.getLength();
              return Text('There $numBikes bikes nearby.');
            } else {
              return const Text('Searching for bikes...');
            }
          }
        ),  
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.map,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapsView()),
              );
              debugPrint('Find Bike Near Me Clicked');
            },
          )
        ],
      ),
      endDrawer: const MenuDrawer(),
      body: FutureBuilder<BikeListModel>(
          future: currentList,
          builder: (context, AsyncSnapshot<BikeListModel> snapshot) {
            if (snapshot.hasData) {
              BikeListModel bikeList = snapshot.data!;
              return Column(
                children:[
                
                  // Title Filter Type
                  Text('Filter by Type:',
                    style:  TextStyle(
                      fontFamily: 'Raleway' ,
                      fontSize: 26, 
                      fontWeight: FontWeight.bold,
                      color:Colors.blue.shade900)
                  ),
                  
                  // Size Radio Button Labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const[
                      Text('none') ,
                      Text('road') ,
                      Text('mountain') ,
                    ],
                  ),

                  //Type Filter Radio Buttons
                  Row(
                    children: [
                       Expanded(//type 'none' radio button
                        child: Radio<Type>(
                          value: Type.none,
                          groupValue: _type,
                          onChanged: (Type? value) {
                            setState(() {
                              _type = value;
                              tags['type'] = '';
                              currentList = getBikeList(
                                size:tags['size'],
                                type:tags['type']
                              );
                            });
                          },
                        ),
                      ),
                      Expanded(///type 'road' radio button
                        child: Radio<Type>(
                          value: Type.road,
                          groupValue: _type,
                          onChanged: (Type? value) {
                            setState(() {
                              _type = value;
                              tags['type'] = 'road';
                              currentList = getBikeList(
                                size:tags['size'],
                                type:tags['type']
                              );
                            });
                          },
                        ),
                      ),
                       Expanded(//type 'mountain' radio button
                        child: Radio<Type>(
                          value: Type.mountain,
                          groupValue: _type,
                          onChanged: (Type? value) {
                            setState(() {
                              _type = value;
                              tags['type'] = 'mountain';
                              currentList = getBikeList(
                                size:tags['size'],
                                type:tags['type']
                              );
                            });
                          },
                        ),
                      ),
                    ]
                  ),

                  // Title Filter Type:
                  Text('Filter Size:',
                    style:  TextStyle(
                      fontFamily: 'Raleway' ,
                      fontSize: 26, 
                      fontWeight: FontWeight.bold,
                      color:Colors.blue.shade900)
                  ),
                  
                  // Type Radio Button Labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const[
                      Text('none') ,
                      Text('small') ,
                      Text('medium') ,
                      Text('large') ,
                    ],
                  ),


                  //Size Filter Radio Buttons
                  Row(
                    children: [
                       Expanded(//none radio button
                        child: Radio<Size>(
                          value: Size.none,
                          groupValue: _size,
                          onChanged: (Size? value) {
                            setState(() {
                              _size = value;
                              tags['size'] = '';
                              currentList = getBikeList(
                                size:tags['size'],
                                type:tags['type']
                              );
                            });
                          },
                        ),
                      ),
                      Expanded(///small radio button
                        child: Radio<Size>(
                          value: Size.small,
                          groupValue: _size,
                          onChanged: (Size? value) {
                            setState(() {
                              _size = value;
                              tags['size'] = 'small';
                              currentList = getBikeList(
                                size:tags['size'],
                                type:tags['type']
                              );
                            });
                          },
                        ),
                      ),
                       Expanded(//medium radio button
                        child: Radio<Size>(
                          value: Size.medium,
                          groupValue: _size,
                          onChanged: (Size? value) {
                            setState(() {
                              _size = value;
                              tags['size'] = 'medium';
                              currentList = getBikeList(
                                size:tags['size'],
                                type:tags['type']
                              );
                            });
                          },
                        ),
                      ),
                      Expanded(//large radio button
                        child: Radio<Size>(
                          value: Size.large,
                          groupValue: _size,
                          onChanged: (Size? value) {
                            setState(() {
                              _size = value;
                              tags['size'] = 'large';
                              currentList = getBikeList(
                                size:tags['size'],
                                type:tags['type']
                              );
                            });
                          },
                        ),
                      ),
                    ]
                  ),
                  Divider(
                    height: 20,
                    thickness: 5,
                    endIndent: 0,
                    color: Colors.blue.shade900,
                  ),


                  Flexible(
                    child: ListView.builder(
                      itemCount: bikeList.getLength(),
                      itemBuilder: (context, i) {
                        if (bikeList.bikes[i].getCheckOutId() != '-1') {
                          return Container();
                        } else {
                          return BikeListTile(bikeData: bikeList.bikes[i]);
                        }
                      }
                    )
                  ),
                ]
              );  
            } else {
              return const CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            GetPhoto.routeName,
          );
          debugPrint('add bike clicked');
        },
        tooltip: buttonToolTipText,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}


// information/instructions: Displays info for one bike for the
// BikeListView(). Each tile is clickable and should navigate to
// the BikeDetailView for that particular bike.
// @params: Bike()
// @return: View of bike basic info, including photo, name, distance,
// rating
// bugs: no known bugs
class BikeListTile extends StatelessWidget {
  final Bike bikeData;
  final distanceFromUser = 1;
  const BikeListTile({
    Key? key,
    required this.bikeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    num averageRating = bikeData.getAverageRating();
    String bikeNameString = 'Name: "' + bikeData.getName() + '"';
    String typeString = 'Type:' + bikeData.getType();
    String sizeString = 'Size: ' + bikeData.getSize();
    String bikeImageUrl = bikeData.getImageUrl();
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BikeDetailView(bikeData: bikeData)));
        },
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row( // top row of an individual bike listing
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(bikeNameString),
                  Column(children: [
                    Text(typeString),
                    Text(sizeString)
                  ],)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(bikeImageUrl,
                    width: 100,
                    fit:BoxFit.cover  
                  ), 
                  const Text('average rating:'),
                  RatingBarIndicator(
                    rating: averageRating.toDouble(),
                    itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 25.0,
                    direction: Axis.horizontal,
                  ), 
                ],
              ),
              const Divider(
                height: 20,
                thickness: 5,
                endIndent: 0,
                color: Colors.grey,
              ),
            ] 
          )
        )
      );
  }
}