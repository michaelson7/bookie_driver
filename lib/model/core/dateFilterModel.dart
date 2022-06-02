class DateFilterModel {
  DateFilterModel({
    this.typename,
    this.dateFilter,
  });

  String? typename;
  List<DateFilter>? dateFilter;

  factory DateFilterModel.fromJson(Map<String, dynamic> json) =>
      DateFilterModel(
        typename: json["__typename"] == null ? null : json["__typename"],
        dateFilter: json["dateFilter"] == null
            ? null
            : List<DateFilter>.from(
                json["dateFilter"].map((x) => DateFilter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "dateFilter": dateFilter == null
            ? null
            : List<dynamic>.from(dateFilter!.map((x) => x.toJson())),
      };
}

class DateFilter {
  DateFilter({
    this.typename,
    this.start,
    this.end,
    this.driver,
    this.amount,
    required this.type,
    this.createdDate,
    this.modifiedDate,
    this.driverratingsSet,
  });

  String? typename;
  End? start;
  String type;
  End? end;
  Driver? driver;
  String? amount;
  DateTime? createdDate;
  DateTime? modifiedDate;
  List<DriverratingsSet>? driverratingsSet;

  factory DateFilter.fromJson(Map<String, dynamic> json) => DateFilter(
        typename: json["__typename"] == null ? null : json["__typename"],
        type: json["type"] == null ? null : json["type"],
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
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
