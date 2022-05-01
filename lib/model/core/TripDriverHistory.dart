class TripDriverHistory {
  TripDriverHistory({
    this.typename,
    this.b2BTrips,
    this.c2BTrips,
  });

  String? typename;
  List<C2BTrip>? b2BTrips;
  List<C2BTrip>? c2BTrips;

  factory TripDriverHistory.fromJson(Map<String, dynamic> json) =>
      TripDriverHistory(
        typename: json["__typename"] == null ? null : json["__typename"],
        b2BTrips: json["b2BTrips"] == null
            ? null
            : List<C2BTrip>.from(
                json["b2BTrips"].map((x) => C2BTrip.fromJson(x))),
        c2BTrips: json["c2bTrips"] == null
            ? null
            : List<C2BTrip>.from(
                json["c2bTrips"].map((x) => C2BTrip.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "c2bTrips": c2BTrips == null
            ? null
            : List<dynamic>.from(c2BTrips!.map((x) => x.toJson())),
      };
}

class C2BTrip {
  C2BTrip({
    this.typename,
    this.start,
    this.end,
    this.amount,
    this.createdDate,
    this.modifiedDate,
    this.driverratingsSet,
  });

  String? typename;
  End? start;
  End? end;
  String? amount;
  DateTime? createdDate;
  DateTime? modifiedDate;
  List<DriverratingsSet>? driverratingsSet;

  factory C2BTrip.fromJson(Map<String, dynamic> json) => C2BTrip(
        typename: json["__typename"] == null ? null : json["__typename"],
        start: json["start"] == null ? null : End.fromJson(json["start"]),
        amount: json["amount"] == null ? null : json["amount"],
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
            : List<dynamic>.from(driverratingsSet!.map((x) => x.toJson())),
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

class End {
  End({
    required this.typename,
    required this.name,
  });

  String typename;
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
