class TripListModel {
  TripListModel({
    this.typename,
    this.allRequestTrip,
  });

  String? typename;
  List<AllRequestTrip>? allRequestTrip;

  factory TripListModel.fromJson(Map<String, dynamic>? json) => TripListModel(
        typename: json?["__typename"],
        allRequestTrip: List<AllRequestTrip>.from(
            json?["allRequestTrip"].map((x) => AllRequestTrip.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "allRequestTrip":
            List<dynamic>.from(allRequestTrip!.map((x) => x.toJson())),
      };
}

class AllRequestTrip {
  AllRequestTrip({
    required this.typename,
    required this.id,
    required this.user,
    required this.status,
    this.pickupLocation,
    this.endLocation,
  });

  String typename;
  String id;
  User user;
  String status;
  Location? pickupLocation;
  Location? endLocation;

  factory AllRequestTrip.fromJson(Map<String, dynamic> json) => AllRequestTrip(
        typename: json["__typename"],
        id: json["id"],
        user: User.fromJson(json["user"]),
        status: json["status"],
        pickupLocation: json["pickupLocation"] != null
            ? Location.fromJson(json["pickupLocation"])
            : null,
        endLocation: json["endLocation"] != null
            ? Location.fromJson(json["endLocation"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "id": id,
        "user": user.toJson(),
        "status": status,
        "pickupLocation": pickupLocation!.toJson(),
        "endLocation": endLocation!.toJson(),
      };
}

class Location {
  Location({
    required this.typename,
    required this.latitude,
    required this.longitude,
    this.LocationName,
  });

  String typename;
  String latitude;
  String longitude;
  String? LocationName;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        typename: json["__typename"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        LocationName: json["LocationName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "latitude": latitude,
        "longitude": longitude,
        "endLocationName": LocationName,
      };
}

class User {
  User({
    required this.typename,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  String typename;
  String firstName;
  String lastName;
  String phoneNumber;

  factory User.fromJson(Map<String, dynamic> json) => User(
        typename: json["__typename"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
      };
}
