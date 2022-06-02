class TripDriverHistory {
  TripDriverHistory({
    this.typename,
    this.b2BTrips,
    this.c2BTrips,
  });

  String? typename;
  List<The2BTrip>? b2BTrips;
  List<The2BTrip>? c2BTrips;

  factory TripDriverHistory.fromJson(Map<String, dynamic> json) =>
      TripDriverHistory(
        typename: json["__typename"] == null ? null : json["__typename"],
        b2BTrips: json["b2bTrips"] == null
            ? null
            : List<The2BTrip>.from(
                json["b2bTrips"].map((x) => The2BTrip.fromJson(x))),
        c2BTrips: json["c2bTrips"] == null
            ? null
            : List<The2BTrip>.from(
                json["c2bTrips"].map((x) => The2BTrip.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "b2bTrips": b2BTrips == null
            ? null
            : List<dynamic>.from(b2BTrips!.map((x) => x.toJson())),
        "c2bTrips": c2BTrips == null
            ? null
            : List<dynamic>.from(c2BTrips!.map((x) => x.toJson())),
      };
}

class The2BTrip {
  The2BTrip({
    this.typename,
    this.start,
    this.end,
    this.driver,
    required this.createdDate,
    required this.amount,
    required this.modifiedDate,
    this.driverratingsSet,
  });

  B2BTripTypename? typename;
  End? start;
  End? end;
  Driver? driver;
  DateTime? createdDate;
  String amount;
  DateTime? modifiedDate;
  List<DriverratingsSet>? driverratingsSet;

  factory The2BTrip.fromJson(Map<String, dynamic> json) => The2BTrip(
        typename: json["__typename"] == null
            ? null
            : b2BTripTypenameValues.map![json["__typename"]],
        start: json["start"] == null ? null : End.fromJson(json["start"]),
        end: json["end"] == null ? null : End.fromJson(json["end"]),
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        amount: json["amount"] == null ? null : json["amount"],
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        driverratingsSet: json["driverratingsSet"] == null
            ? null
            : List<DriverratingsSet>.from(json["driverratingsSet"]
                .map((x) => DriverratingsSet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename":
            typename == null ? null : b2BTripTypenameValues.reverse![typename],
        "start": start == null ? null : start!.toJson(),
        "end": end == null ? null : end!.toJson(),
        "createdDate":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "amount": amount == null ? null : amount,
        "modifiedDate":
            modifiedDate == null ? null : modifiedDate!.toIso8601String(),
        "driverratingsSet": driverratingsSet == null
            ? null
            : List<dynamic>.from(driverratingsSet!.map((x) => x.toJson())),
      };
}

class Driver {
  Driver({
    this.typename,
    this.drivervehicleSet,
  });

  String? typename;
  List<DrivervehicleSet>? drivervehicleSet;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        typename: json["__typename"] == null ? null : json["__typename"],
        drivervehicleSet: json["drivervehicleSet"] == null
            ? null
            : List<DrivervehicleSet>.from(json["drivervehicleSet"]
                .map((x) => DrivervehicleSet.fromJson(x))),
      );
}

class DrivervehicleSet {
  DrivervehicleSet({
    this.typename,
    this.modelName,
    this.modelColor,
  });

  String? typename;
  String? modelName;
  String? modelColor;

  factory DrivervehicleSet.fromJson(Map<String, dynamic> json) =>
      DrivervehicleSet(
        typename: json["__typename"] == null ? null : json["__typename"],
        modelName: json["modelName"] == null ? null : json["modelName"],
        modelColor: json["modelColor"] == null ? null : json["modelColor"],
      );
}

class DriverratingsSet {
  DriverratingsSet({
    required this.typename,
    required this.rateLevel,
  });

  String typename;
  int rateLevel;

  factory DriverratingsSet.fromJson(Map<String, dynamic> json) =>
      DriverratingsSet(
        typename: json["__typename"] == null ? null : json["__typename"],
        rateLevel: json["rateLevel"] == null ? null : json["rateLevel"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "rateLevel": rateLevel == null ? null : rateLevel,
      };
}

class End {
  End({
    required this.typename,
    required this.name,
  });

  EndTypename? typename;
  String name;

  factory End.fromJson(Map<String, dynamic> json) => End(
        typename: json["__typename"] == null
            ? null
            : endTypenameValues.map![json["__typename"]],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "__typename":
            typename == null ? null : endTypenameValues.reverse![typename],
        "name": name == null ? null : name,
      };
}

enum EndTypename { LOCATION_TYPE }

final endTypenameValues =
    EnumValues({"LocationType": EndTypename.LOCATION_TYPE});

enum B2BTripTypename { TRIP_TYPE }

final b2BTripTypenameValues =
    EnumValues({"TripType": B2BTripTypename.TRIP_TYPE});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
