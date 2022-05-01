// To parse this JSON data, do
//
//     final tripListModel = tripListModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/rendering.dart';

import 'UserDataModel.dart';

TripListModel tripListModelFromJson(String str) =>
    TripListModel.fromJson(json.decode(str));

String tripListModelToJson(TripListModel data) => json.encode(data.toJson());

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
    this.vehicleClass,
    required this.type,
    required this.user,
    required this.status,
    required this.pickupLocation,
    required this.endLocation,
    this.businessrequesttripSet,
  });

  String typename;
  String id;
  VehicleClass? vehicleClass;
  String type;
  Me? user;
  String? total;
  String status;
  Location? pickupLocation;
  Location? endLocation;
  List<BusinessrequesttripSet>? businessrequesttripSet;

  factory AllRequestTrip.fromJson(Map<String, dynamic> json) => AllRequestTrip(
        typename: json["__typename"] == null ? null : json["__typename"],
        id: json["id"] == null ? null : json["id"],
        vehicleClass: json["vehicleClass"] == null
            ? null
            : VehicleClass.fromJson(json["vehicleClass"]),
        type: json["type"] == null ? null : json["type"],
        user: json["user"] == null ? null : Me.fromJson(json["user"]),
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
        "vehicleClass": vehicleClass == null ? null : vehicleClass!.toJson(),
        "type": type == null ? null : type,
        "user": user == null ? null : user!.toJson(),
        "status": status == null ? null : status,
        "pickupLocation":
            pickupLocation == null ? null : pickupLocation!.toJson(),
        "endLocation": endLocation == null ? null : endLocation!.toJson(),
        "businessrequesttripSet": businessrequesttripSet == null
            ? null
            : List<dynamic>.from(businessrequesttripSet!.map((x) => x)),
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

class VehicleClass {
  VehicleClass({
    required this.typename,
    required this.name,
    required this.vehiclebasepriceSet,
  });

  String typename;
  String name;
  List<VehiclebasepriceSet>? vehiclebasepriceSet;

  factory VehicleClass.fromJson(Map<String, dynamic> json) => VehicleClass(
        typename: json["__typename"] == null ? null : json["__typename"],
        name: json["name"] == null ? null : json["name"],
        vehiclebasepriceSet: json["vehiclebasepriceSet"] == null
            ? null
            : List<VehiclebasepriceSet>.from(json["vehiclebasepriceSet"]
                .map((x) => VehiclebasepriceSet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "name": name == null ? null : name,
        "vehiclebasepriceSet": vehiclebasepriceSet == null
            ? null
            : List<dynamic>.from(vehiclebasepriceSet!.map((x) => x.toJson())),
      };
}

class VehiclebasepriceSet {
  VehiclebasepriceSet({
    required this.typename,
    required this.price,
    required this.rate,
  });

  String typename;
  String price;
  String rate;

  factory VehiclebasepriceSet.fromJson(Map<String, dynamic> json) =>
      VehiclebasepriceSet(
        typename: json["__typename"] == null ? null : json["__typename"],
        price: json["price"] == null ? null : json["price"],
        rate: json["rate"] == null ? null : json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "price": price == null ? null : price,
        "rate": rate == null ? null : rate,
      };
}

class BusinessrequesttripSet {
  BusinessrequesttripSet({
    required this.typename,
    required this.tripDescription,
    this.skills,
    this.file,
  });

  String typename;
  String tripDescription;
  List<Skill>? skills;
  String? file;

  factory BusinessrequesttripSet.fromJson(Map<String, dynamic> json) =>
      BusinessrequesttripSet(
        typename: json["__typename"] == null ? null : json["__typename"],
        tripDescription:
            json["tripDescription"] == null ? null : json["tripDescription"],
        skills: json["skills"] == null
            ? null
            : List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
        file: json["file"] == null
            ? null
            : "https://bookie-media.s3.af-south-1.amazonaws.com/" +
                json["file"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "tripDescription": tripDescription == null ? null : tripDescription,
        "skills": skills == null
            ? null
            : List<dynamic>.from(skills!.map((x) => x.toJson())),
        "file": file == null ? null : file,
      };
}

class Skill {
  Skill({
    required this.typename,
    required this.id,
    required this.name,
  });

  String typename;
  String id;
  String name;

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        typename: json["__typename"] == null ? null : json["__typename"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
