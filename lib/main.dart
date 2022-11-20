// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:m_expense_flutter/firebase_options.dart';
import 'package:m_expense_flutter/m_expense/my_trips.dart';
import 'package:m_expense_flutter/m_expense/new_trip.dart';
import 'package:m_expense_flutter/m_expense/route_names.dart';
import 'package:m_expense_flutter/m_expense/trip_entity.dart';
import 'package:m_expense_flutter/m_expense/welcome.dart';

// void main() {
//   runApp(const MExpense());
// }

Future main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {}
  runApp(const MExpense());
}

class MExpense extends StatelessWidget {
  const MExpense({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RouteNames.Welcome: (context) => const Welcome(),
        RouteNames.NewTrip: (context) => NewTrip(
              theTrip: TripEntity.empty(),
            ),
        RouteNames.Trips: (context) => const MyTrips(),
      },
      initialRoute: RouteNames.Trips,
    );
  }
}
