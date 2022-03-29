class AllRequestTrips {
  AllRequestTrips({
    this.typename,
    this.allRequestTrip,
  });

  String? typename;
  List<AllRequestTrip>? allRequestTrip;

  factory AllRequestTrips.fromJson(Map<String, dynamic> json) =>
      AllRequestTrips(
        typename: json["__typename"],
        allRequestTrip: List<AllRequestTrip>.from(
            json["allRequestTrip"].map((x) => AllRequestTrip.fromJson(x))),
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
    required this.pickupLocation,
  });

  String typename;
  String id;
  User user;
  String status;
  PickupLocation pickupLocation;

  factory AllRequestTrip.fromJson(Map<String, dynamic> json) => AllRequestTrip(
        typename: json["__typename"],
        id: json["id"],
        user: User.fromJson(json["user"]),
        status: json["status"],
        pickupLocation: PickupLocation.fromJson(json["pickupLocation"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "id": id,
        "user": user.toJson(),
        "status": status,
        "pickupLocation": pickupLocation.toJson(),
      };
}

class PickupLocation {
  PickupLocation({
    required this.typename,
    required this.latitude,
    required this.longitude,
  });

  String typename;
  String latitude;
  String longitude;

  factory PickupLocation.fromJson(Map<String, dynamic> json) => PickupLocation(
        typename: json["__typename"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "latitude": latitude,
        "longitude": longitude,
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
