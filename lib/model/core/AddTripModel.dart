class AddTripModel {
  AddTripModel({
    this.typename,
    this.addRequestTrip,
  });

  String? typename;
  AddRequestTrip? addRequestTrip;

  factory AddTripModel.fromJson(Map<String, dynamic>? json) => AddTripModel(
        typename: json?["__typename"],
        addRequestTrip: AddRequestTrip.fromJson(json?["addRequestTrip"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "addRequestTrip": addRequestTrip?.toJson(),
      };
}

class AddRequestTrip {
  AddRequestTrip({
    required this.typename,
    required this.response,
    required this.message,
  });

  String typename;
  int response;
  String message;

  factory AddRequestTrip.fromJson(Map<String, dynamic> json) => AddRequestTrip(
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
