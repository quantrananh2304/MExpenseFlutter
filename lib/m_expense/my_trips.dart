import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m_expense_flutter/m_expense/new_trip.dart';
import 'package:m_expense_flutter/m_expense/route_names.dart';
import 'package:m_expense_flutter/m_expense/trip_entity.dart';

class MyTrips extends StatelessWidget {
  const MyTrips({Key? key}) : super(key: key);

  get handleClick => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My Trips"), actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Delete All'}.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice,
                    child: InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Warning!"),
                          content: const Text(
                              "Are you sure to delete all data?\nThis action cannot be undone!"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => deleteAll(context),
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "Delete All",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    ));
              }).toList();
            },
          ),
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.NewTrip);
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add)),
        body: StreamBuilder<List<TripEntity>>(
            stream: readTrips(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong! $snapshot");
              } else if (snapshot.hasData) {
                final trips = snapshot.data!;

                return buildListView(trips);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  void deleteAll(context) async {
    var collection =
        FirebaseFirestore.instance.collection(TripConstants.fsTrip);

    var snapshots = await collection.get();

    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    Navigator.pop(context);
  }

  ListView buildListView(List<TripEntity> trips) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final t = trips[index];
        List<String> nameSplitted = t.name.split(" ");
        String initial = nameSplitted[0].split('')[0];

        if (nameSplitted.length == 2) {
          initial += nameSplitted[1].split('')[0];
        }

        return ListTile(
            onTap: () {
              print(t.id);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewTrip(theTrip: t)));
            },
            leading: CircleAvatar(child: Text('$initial')),
            title: Text(t.name,
                style: const TextStyle(color: Colors.black, fontSize: 20.0)));
      },
    );
  }

  Stream<List<TripEntity>> readTrips() {
    return FirebaseFirestore.instance
        .collection(TripConstants.fsTrip)
        .snapshots()
        .map((querySnap) => querySnap.docs
            .map((doc) => TripEntity.fromJson(doc.id, doc.data()))
            .toList());
  }
}
