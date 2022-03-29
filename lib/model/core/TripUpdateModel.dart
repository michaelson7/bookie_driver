class TripUpdateModel {
  TripUpdateModel({
    this.typename,
    this.updateRequestTrip,
  });

  String? typename;
  UpdateRequestTrip? updateRequestTrip;

  factory TripUpdateModel.fromJson(Map<String, dynamic>? json) =>
      TripUpdateModel(
        typename: json?["__typename"],
        updateRequestTrip:
            UpdateRequestTrip.fromJson(json?["updateRequestTrip"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "updateRequestTrip": updateRequestTrip?.toJson(),
      };
}

class UpdateRequestTrip {
  UpdateRequestTrip({
    required this.typename,
    required this.response,
    required this.message,
  });

  String typename;
  String response;
  String message;

  factory UpdateRequestTrip.fromJson(Map<String, dynamic> json) =>
      UpdateRequestTrip(
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
