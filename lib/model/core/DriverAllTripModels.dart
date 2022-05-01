class DriverAllTripHostory {
  DriverAllTripHostory({
    this.typename,
    this.allMyTrips,
  });

  String? typename;
  List<AllMyTrip>? allMyTrips;

  factory DriverAllTripHostory.fromJson(Map<String, dynamic> json) =>
      DriverAllTripHostory(
        typename: json["__typename"] == null ? null : json["__typename"],
        allMyTrips: json["allMyTrips"] == null
            ? null
            : List<AllMyTrip>.from(
                json["allMyTrips"].map((x) => AllMyTrip.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "allMyTrips": allMyTrips == null
            ? null
            : List<dynamic>.from(allMyTrips!.map((x) => x.toJson())),
      };
}

class AllMyTrip {
  AllMyTrip({
    required this.typename,
    required this.start,
    required this.end,
    required this.amount,
    required this.createdDate,
    required this.modifiedDate,
    this.driverratingsSet,
  });

  String typename;
  End? start;
  End? end;
  String amount;
  DateTime? createdDate;
  DateTime? modifiedDate;
  List<DriverratingsSet>? driverratingsSet;

  factory AllMyTrip.fromJson(Map<String, dynamic> json) => AllMyTrip(
        typename: json["__typename"] == null ? null : json["__typename"],
        amount: json["amount"] == null ? null : json["amount"],
        start: json["start"] == null ? null : End.fromJson(json["start"]),
        end: json["end"] == null ? null : End.fromJson(json["end"]),
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        driverratingsSet: json["driverratingsSet"] == null
            ? null
            : List<DriverratingsSet>.from(json["driverratingsSet"]
                .map((x) => DriverratingsSet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "start": start == null ? null : start!.toJson(),
        "end": end == null ? null : end!.toJson(),
        "createdDate":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "modifiedDate":
            modifiedDate == null ? null : modifiedDate!.toIso8601String(),
        "driverratingsSet": driverratingsSet == null
            ? null
            : List<dynamic>.from(driverratingsSet!.map((x) => x)),
      };
}

class End {
  End({
    required this.typename,
    required this.name,
  });

  String? typename;
  String name;

  factory End.fromJson(Map<String, dynamic> json) => End(
        typename: json["__typename"] == null ? null : json["__typename"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "name": name == null ? null : name,
      };
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
