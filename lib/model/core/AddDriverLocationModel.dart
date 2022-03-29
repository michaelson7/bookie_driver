class AddDriverLocationModel {
  AddDriverLocationModel({
    this.typename,
    this.addDriverLocation,
  });

  String? typename;
  AddDriverLocation? addDriverLocation;

  factory AddDriverLocationModel.fromJson(Map<String, dynamic>? json) =>
      AddDriverLocationModel(
        typename: json?["__typename"],
        addDriverLocation:
            AddDriverLocation.fromJson(json?["addDriverLocation"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "addDriverLocation": addDriverLocation?.toJson(),
      };
}

class AddDriverLocation {
  AddDriverLocation({
    required this.typename,
    required this.response,
    required this.message,
  });

  String typename;
  int response;
  String message;

  factory AddDriverLocation.fromJson(Map<String, dynamic> json) =>
      AddDriverLocation(
        typename: json["__typename"],
        response: json["response"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "response": response,
        "message": message,
      };
}
