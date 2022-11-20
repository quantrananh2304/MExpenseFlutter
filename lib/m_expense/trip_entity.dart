class TripConstants {
  static const String emptyString = "";
  static const String newTripId = "0";
  static const String fireStore = "firebase";
  static const String fsTrip = "trip";
}

class TripEntity {
  String id = TripConstants.newTripId;
  String name = TripConstants.emptyString;
  String destination = TripConstants.emptyString;
  String date = TripConstants.emptyString;
  bool risk = false;
  String description = TripConstants.emptyString;

  TripEntity(this.id, this.name, this.destination, this.date, this.risk,
      this.description);

  TripEntity.newTrip(String name, String destination, String date, bool risk,
      String description)
      : this(TripConstants.newTripId, name, destination, date, risk,
            description);

  TripEntity.empty();

  static TripEntity fromJson(String docId, Map<String, dynamic> json) {
    return TripEntity(docId, json['name'], json['destination'], json['date'],
        json['risk'], json['description']);
  }

  Map<String, dynamic> getHashMap() {
    return <String, dynamic>{
      "name": name,
      "destination": destination,
      "date": date,
      "risk": risk,
      "description": description
    };
  }
}
