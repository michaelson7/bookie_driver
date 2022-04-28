import 'package:bookie_driver/model/core/UserDataModel.dart';

class TripListModel {
  TripListModel({
    this.typename,
    this.allRequestTrip,
  });

  String? typename;
  List<AllRequestTrip>? allRequestTrip;

  factory TripListModel.fromJson(Map<String, dynamic> json) => TripListModel(
        typename: json["__typename"] == null ? null : json["__typename"],
        allRequestTrip: json["allRequestTrip"] == null
            ? null
            : List<AllRequestTrip>.from(
                json["allRequestTrip"].map((x) => AllRequestTrip.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "allRequestTrip": allRequestTrip == null
            ? null
            : List<dynamic>.from(allRequestTrip!.map((x) => x.toJson())),
      };
}

class AllRequestTrip {
  AllRequestTrip({
    required this.typename,
    required this.id,
    required this.type,
    this.user,
    required this.status,
    this.pickupLocation,
    this.endLocation,
    this.businessrequesttripSet,
  });

  String typename;
  String id;
  String type;
  User? user;
  String status;
  Location? pickupLocation;
  Location? endLocation;
  List<BusinessrequesttripSet>? businessrequesttripSet;

  factory AllRequestTrip.fromJson(Map<String, dynamic> json) => AllRequestTrip(
        typename: json["__typename"] == null ? null : json["__typename"],
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        status: json["status"] == null ? null : json["status"],
        pickupLocation: json["pickupLocation"] == null
            ? null
            : Location.fromJson(json["pickupLocation"]),
        endLocation: json["endLocation"] == null
            ? null
            : Location.fromJson(json["endLocation"]),
        businessrequesttripSet: json["businessrequesttripSet"] == null
            ? null
            : List<BusinessrequesttripSet>.from(json["businessrequesttripSet"]
                .map((x) => BusinessrequesttripSet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "user": user == null ? null : user!.toJson(),
        "status": status == null ? null : status,
        "pickupLocation":
            pickupLocation == null ? null : pickupLocation!.toJson(),
        "endLocation": endLocation == null ? null : endLocation!.toJson(),
        "businessrequesttripSet": businessrequesttripSet == null
            ? null
            : List<dynamic>.from(
                businessrequesttripSet!.map((x) => x.toJson())),
      };
}

class BusinessrequesttripSet {
  BusinessrequesttripSet({
    this.typename,
    this.tripDescription,
  });

  String? typename;
  String? tripDescription;

  factory BusinessrequesttripSet.fromJson(Map<String, dynamic> json) =>
      BusinessrequesttripSet(
        typename: json["__typename"] == null ? null : json["__typename"],
        tripDescription:
            json["tripDescription"] == null ? null : json["tripDescription"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "tripDescription": tripDescription == null ? null : tripDescription,
      };
}

class Location {
  Location({
    required this.typename,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  String typename;
  String latitude;
  String longitude;
  String name;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        typename: json["__typename"] == null ? null : json["__typename"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "name": name == null ? null : name,
      };
}

class User {
  User({
    required this.typename,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.profilepictureSet,
  });

  String typename;
  String firstName;
  String lastName;
  String phoneNumber;
  List<ProfilepictureSet>? profilepictureSet;

  factory User.fromJson(Map<String, dynamic> json) => User(
        typename: json["__typename"] == null ? null : json["__typename"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        profilepictureSet: json["profilepictureSet"] == null
            ? null
            : List<ProfilepictureSet>.from(json["profilepictureSet"]
                .map((x) => ProfilepictureSet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "profilepictureSet": profilepictureSet == null
            ? null
            : List<dynamic>.from(profilepictureSet!.map((x) => x.toJson())),
      };
}
