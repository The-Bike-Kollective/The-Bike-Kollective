import 'package:flutter/material.dart';
import 'package:the_bike_kollective/get-photo.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'models.dart';
import 'MenuDrawer.dart';
import 'bike_detail_view.dart';
import 'Maps/googlemaps.dart';
import 'requests.dart';

// information/instructions: Renders the bike list from the
// BikeListModel object's data.
// @params: BikeListModel
// @return:
// bugs: no known bugs
// TODO:
// 1. This maybe should be stateless, I'm not sure.
// If we include sort filters, it may be the case that
// stateful is what we want, so that the list will render differently
// based on which filters are used.
class BikeListView extends StatefulWidget {
  const BikeListView({Key? key}) : super(key: key);
  static const routeName = '/bike-list';
  @override
  State<BikeListView> createState() => _BikeListViewState();
}



enum Size {none, small, medium, large}
enum Type {none, road, mountain}
// This is the state object that is called by BikeListView().
class _BikeListViewState extends State<BikeListView> {
  String buttonToolTipText = "add a bike";
  //const num numofBikes = 0;
  Future<BikeListModel> currentList = getBikeList();
  String size = "";
  String type = "";
  Size? _size = Size.none;
  Type? _type = Type.none;
  Map tags = {'size': '', 'type': ''};
  


  @override
  // I'm not totally sure what this does or if we need it.
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
                  const Text('Filter by Type:',
                    style: TextStyle(fontSize: 18)
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
                  const Text('Filter Size:',
                    style: TextStyle(fontSize: 18)
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

                  Flexible(
                    child: ListView.builder(
                      itemCount: bikeList.getLength(),
                      itemBuilder: (context, i) {
                        //TODO: (this looks wrong, double check it)
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
          // Add your onPressed code here!
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

// information/instructions: This Widget is rendered within the
//BikeListView widget.
// @params: BikeListModel
// @return: rendering of bikeList
// bugs: no known bugs
class BikeListBody extends StatelessWidget {
  final BikeListModel bikeList;
  const BikeListBody({Key? key, required this.bikeList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        const Text('Filter by size:'),
        Flexible(
          child: ListView.builder(
            itemCount: bikeList.getLength(),
            itemBuilder: (context, i) {
              //TODO: (this looks wrong, double check it)
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
    
  }
}

// information/instructions: Displays info for one bike for the
// BikeListView(). Each tile is clickable and should navigate to
// the BikeDetailView for that particular bike.
// @params: Bike()
// @return: View of bike basic info, including photo, name, distance,
// rating
// bugs: no known bugs
// TODO:
// 1. Distance: will need to calculate the distance from the bike's
//  location to the user's current location.
// 2. Clean up the style.
// 3.
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
    String bikeNameString = bikeData.getName();
    String distanceString = 'distance:' + distanceFromUser.toString();
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
                  Text(distanceString)
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
                   // placeholder for stars
                  //(averageRating == -1.0) ? const Text('(no ratings yet)') 
                  //:
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
                  //RatingStars(rating: bikeRating)   
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

// information/instructions: Renders a row with the string "rating: "
// followed by 5 yellow stars. Stars will be filled in according to
// the rating parameter.
// @params: double rating
// @return: star rating
// bugs: no known bugs
// TODO:
// 1. Right now it only works when the rating provided is an integer,
// even though we are using the double data type. In the planning doc,
// rating is specified as a float, but dart only has int and double (at
// least if I understood what I read correctly.)
// 2.
// 3.
class RatingStars extends StatelessWidget {
  final num rating;
  final numStarsPossible = 5;
  const RatingStars({Key? key, this.rating = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('rating:'),
        Row(
          //row of stars
          mainAxisSize: MainAxisSize.min,
          children: List.generate(numStarsPossible, (index) {
            return Icon(index < rating ? Icons.star : Icons.star_border,
                color: const Color(0xFFFDCC0D));
          }),
        )
      ],
    );
  }
}
// TODO: 
// 2. 
// 3. 
// class RatingStars extends StatelessWidget {
//   final num rating;
//   final numStarsPossible = 5;  
//   const RatingStars({Key? key, this.rating = 0})
//       : super(key: key);  
  
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text('rating:'),
//         Row(//row of stars
//           mainAxisSize: MainAxisSize.min,
//           children: List.generate(numStarsPossible, (index) {
//             return Icon(
//               index < rating ? Icons.star : Icons.star_border,
//               color:const Color(0xFFFDCC0D)
//             );
//           }),
//         )
//       ],
//     ); 
      
//   }
// }
