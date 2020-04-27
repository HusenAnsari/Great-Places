import 'package:flutter/material.dart';
import 'package:greatplaces/providers/great_places.dart';
import 'package:greatplaces/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: Center(
        // here centerChild in a child: Center(child: Text('No Places yet!'),
        // it is not update if data update so we defined this in child.
        // And we show centerChild that is "child: Text('No Places yet!')," if data not available in greatPlacesData.items
        // Using FutureBuilder we can get future of provider package.
        // Here we are set listen: false because we no need to rebuild whole build().
        // we need to update Consumer part only and consumer update automatically.
        child: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (context, snapshotData) => snapshotData.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlaces>(
                  child: Center(
                    child: Text('No Places yet!'),
                  ),
                  builder: (context, greatPlacesData, centerChild) =>
                      greatPlacesData.items.length <= 0
                          ? centerChild
                          : ListView.builder(
                              itemCount: greatPlacesData.items.length,
                              itemBuilder: (context, index) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(
                                    greatPlacesData.items[index].image,
                                  ),
                                ),
                                title: Text(greatPlacesData.items[index].title),
                                onTap: () {
                                  // Detail page
                                },
                              ),
                            ),
                ),
        ),
      ),
    );
  }
}
