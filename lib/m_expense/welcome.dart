// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:m_expense_flutter/m_expense/route_names.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.NewTrip);
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
            appBar: AppBar(
              title: const Text('MExpense'),
            ),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/bg.png"), fit: BoxFit.cover)),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.blue.shade100.withOpacity(0.8)),
                  child: const Text(
                    "Sleeping is good\nReading books is better",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            )));
  }
}
