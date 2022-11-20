import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:m_expense_flutter/m_expense/route_names.dart';
import 'package:m_expense_flutter/m_expense/trip_entity.dart';
import 'package:m_expense_flutter/m_expense/welcome.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class NewTrip extends StatefulWidget {
  NewTrip({Key? key, this.theTrip}) : super(key: key);

  TripEntity? theTrip;

  @override
  State<NewTrip> createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDestination = TextEditingController();
  final TextEditingController txtDate = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();

  bool risk = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.theTrip ??= TripEntity.empty();
    txtName.text = widget.theTrip!.name;
    txtDestination.text = widget.theTrip!.destination;
    txtDate.text = widget.theTrip!.date;
    txtDescription.text = widget.theTrip!.description;
    risk = widget.theTrip!.risk;

    super.initState();
  }

  List<Widget> get buildMenus {
    var d = <Widget>[];

    if (widget.theTrip!.id != TripConstants.newTripId) {
      d.add(IconButton(onPressed: deleteTrip, icon: const Icon(Icons.delete)));
      d.add(const Padding(padding: EdgeInsets.symmetric(horizontal: 5)));
    }

    return d;
  }

  void deleteTrip() {
    FirebaseFirestore.instance
        .collection(TripConstants.fsTrip)
        .doc(widget.theTrip!.id)
        .delete()
        .then((_) => goToRoute(RouteNames.Trips, "Document deleted"),
            onError: (e) => print("Error updating document $e"));
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Add a new trip"),
          actions: buildMenus,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                "Trip",
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 18),
                                validator: requiredField,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: txtName,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  hintText: "Trip",
                                ),
                              )),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Destination',
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 18),
                                validator: requiredField,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: txtDestination,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  hintText: "Destination",
                                ),
                              )),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                "Date",
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 18),
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2222))
                                      .then((date) => {
                                            if (date != null)
                                              {
                                                txtDate.text =
                                                    '${date.year}/${date.month < 10 ? '0${date.month}' : date.month}/${date.day < 10 ? '0${date.day}' : date.day}'
                                              }
                                          });
                                },
                                validator: requiredField,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: txtDate,
                                keyboardType: TextInputType.none,
                                decoration: const InputDecoration(
                                  hintText: "Date",
                                ),
                                showCursor: false,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10, right: 10),
                            child: LiteRollingSwitch(
                              value: risk,
                              textOn: "Yes",
                              textOff: "No",
                              iconOff: Icons.close,
                              colorOn: Colors.greenAccent,
                              colorOff: Colors.redAccent,
                              textSize: 16.0,
                              onChanged: (bool position) => {risk = position},
                            ),
                          ),
                          const Text(
                            "Require risk assessment",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Description',
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 18),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: txtDescription,
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                  hintText: "Description",
                                ),
                              )),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                              onPressed: saveTrip,
                              child: Text("Save",
                                  style: TextStyle(fontSize: fontSize)))),
                    ],
                  ))),
        ));
  }

  void saveTrip() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        var currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        var aTrip = TripEntity.newTrip(txtName.text, txtDestination.text,
            txtDate.text, risk, txtDescription.text);

        var tId = widget.theTrip!.id;

        if (tId == TripConstants.newTripId) {
          FirebaseFirestore.instance
              .collection(TripConstants.fsTrip)
              .add(aTrip.getHashMap())
              .then(
                  (docSnapshot) => goToRoute(RouteNames.Trips,
                      "Document added with id: ${docSnapshot.id}"),
                  onError: (e) => print("Error updating document $e"));
        } else {
          FirebaseFirestore.instance
              .collection(TripConstants.fsTrip)
              .doc(tId)
              .update(aTrip.getHashMap())
              .then((_) => goToRoute(RouteNames.Trips, "Document saved"),
                  onError: (e) => print("Error updating document $e"));
        }
      });
    }
  }

  void goToRoute(String routeName, [String msg = ""]) {
    if (msg != "") {
      print(msg);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    txtName.dispose();
    txtDestination.dispose();
    txtDate.dispose();
    txtDescription.dispose();

    super.dispose();
  }

  String? requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }

    return null;
  }
}
