class UserTripData {
  UserTripData({
    this.typename,
    this.requestTripInfo,
  });

  String? typename;
  List<RequestTripInfo>? requestTripInfo;

  factory UserTripData.fromJson(Map<String, dynamic>? json) => UserTripData(
        typename: json?["__typename"],
        requestTripInfo: List<RequestTripInfo>.from(
            json?["requestTripInfo"].map((x) => RequestTripInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "requestTripInfo":
            List<dynamic>.from(requestTripInfo!.map((x) => x.toJson())),
      };
}

class RequestTripInfo {
  RequestTripInfo({
    required this.typename,
    required this.id,
    required this.status,
    required this.endLocation,
    required this.pickupLocation,
    required this.date,
  });

  String typename;
  String id;
  String status;
  Location endLocation;
  Location pickupLocation;
  DateTime date;

  factory RequestTripInfo.fromJson(Map<String, dynamic> json) =>
      RequestTripInfo(
        typename: json["__typename"],
        id: json["id"],
        status: json["status"],
        endLocation: Location.fromJson(json["endLocation"]),
        pickupLocation: Location.fromJson(json["pickupLocation"]),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "id": id,
        "status": status,
        "endLocation": endLocation.toJson(),
        "pickupLocation": pickupLocation.toJson(),
        "date": date.toIso8601String(),
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
        "LocationName": LocationName,
      };
}
