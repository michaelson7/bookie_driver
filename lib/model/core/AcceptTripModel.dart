class AcceptTripModel {
  AcceptTripModel({
    this.typename,
    this.addAcceptTrip,
  });

  String? typename;
  AddAcceptTrip? addAcceptTrip;

  factory AcceptTripModel.fromJson(Map<String, dynamic>? json) =>
      AcceptTripModel(
        typename: json?["__typename"],
        addAcceptTrip: AddAcceptTrip.fromJson(json?["addAcceptTrip"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "addAcceptTrip": addAcceptTrip!.toJson(),
      };
}

class AddAcceptTrip {
  AddAcceptTrip({
    required this.typename,
    required this.response,
    required this.message,
    this.acceptTrip,
  });

  String typename;
  String response;
  String message;
  AcceptTrip? acceptTrip;

  factory AddAcceptTrip.fromJson(Map<String, dynamic>? json) => AddAcceptTrip(
        typename: json?["__typename"],
        response: json?["response"],
        message: json?["message"],
        acceptTrip: AcceptTrip.fromJson(json?["acceptTrip"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "response": response,
        "message": message,
        "acceptTrip": acceptTrip?.toJson(),
      };
}

class AcceptTrip {
  AcceptTrip({
    this.typename,
    this.id,
  });

  String? typename;
  String? id;

  factory AcceptTrip.fromJson(Map<String, dynamic>? json) => AcceptTrip(
        typename: json?["__typename"],
        id: json?["id"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "id": id,
      };
}
