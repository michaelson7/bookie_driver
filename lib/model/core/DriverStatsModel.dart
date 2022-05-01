class DriverStatsModel {
  DriverStatsModel({
    this.typename,
    this.totalTrips,
    this.availableBalance,
    this.tripAcceptanceRate,
    this.totalTripCanceled,
    this.registeredDate,
    this.totalEarnings,
    this.driverDepartment,
    this.driverSkills,
  });

  String? typename;
  int? totalTrips;
  String? totalEarnings;
  String? availableBalance;
  int? tripAcceptanceRate;
  int? totalTripCanceled;
  DateTime? registeredDate;
  DriverDepartment? driverDepartment;
  List<DriverSkill>? driverSkills;

  factory DriverStatsModel.fromJson(Map<String, dynamic> json) =>
      DriverStatsModel(
        driverDepartment: json["driverDepartment"] == null
            ? null
            : DriverDepartment.fromJson(json["driverDepartment"]),
        typename: json["__typename"] == null ? null : json["__typename"],
        driverSkills: json["driverSkills"] == null
            ? null
            : List<DriverSkill>.from(
                json["driverSkills"].map((x) => DriverSkill.fromJson(x))),
        totalTrips: json["totalTrips"] == null ? null : json["totalTrips"],
        totalEarnings:
            json["totalEarnings"] == null ? null : json["totalEarnings"],
        availableBalance:
            json["availableBalance"] == null ? null : json["availableBalance"],
        tripAcceptanceRate: json["tripAcceptanceRate"] == null
            ? null
            : json["tripAcceptanceRate"],
        totalTripCanceled: json["totalTripCanceled"] == null
            ? null
            : json["totalTripCanceled"],
        registeredDate: json["registeredDate"] == null
            ? null
            : DateTime.parse(json["registeredDate"]),
      );

  Map<String, dynamic> toJson() => {
        "driverDepartment":
            driverDepartment == null ? null : driverDepartment!.toJson(),
        "__typename": typename == null ? null : typename,
        "totalTrips": totalTrips == null ? null : totalTrips,
        "totalEarnings": totalEarnings == null ? null : totalEarnings,
        "availableBalance": availableBalance == null ? null : availableBalance,
        "tripAcceptanceRate":
            tripAcceptanceRate == null ? null : tripAcceptanceRate,
        "totalTripCanceled":
            totalTripCanceled == null ? null : totalTripCanceled,
        "registeredDate": registeredDate == null
            ? null
            : "${registeredDate!.year.toString().padLeft(4, '0')}-${registeredDate!.month.toString().padLeft(2, '0')}-${registeredDate!.day.toString().padLeft(2, '0')}",
      };
}

class DriverDepartment {
  DriverDepartment({
    required this.typename,
    required this.name,
    this.business,
  });

  String typename;
  String name;
  Business? business;

  factory DriverDepartment.fromJson(Map<String, dynamic> json) =>
      DriverDepartment(
        typename: json["__typename"] == null ? null : json["__typename"],
        name: json["name"] == null ? null : json["name"],
        business: json["business"] == null
            ? null
            : Business.fromJson(json["business"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "name": name == null ? null : name,
        "business": business == null ? null : business!.toJson(),
      };
}

class Business {
  Business({
    required this.typename,
    required this.name,
  });

  String typename;
  String name;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        typename: json["__typename"] == null ? null : json["__typename"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "name": name == null ? null : name,
      };
}

class DriverSkill {
  DriverSkill({
    required this.typename,
    required this.name,
  });

  String typename;
  String name;

  factory DriverSkill.fromJson(Map<String, dynamic> json) => DriverSkill(
        typename: json["__typename"] == null ? null : json["__typename"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "name": name == null ? null : name,
      };
}
