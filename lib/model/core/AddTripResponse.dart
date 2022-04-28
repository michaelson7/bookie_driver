class AddTripResponse {
  AddTripResponse({
    this.typename,
    this.addTrip,
  });

  String? typename;
  AddTrip? addTrip;

  factory AddTripResponse.fromJson(Map<String, dynamic>? json) =>
      AddTripResponse(
        typename: json?["__typename"],
        addTrip: AddTrip.fromJson(json?["addTrip"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "addTrip": addTrip?.toJson(),
      };
}

class AddTrip {
  AddTrip({
    this.typename,
    this.response,
    this.message,
    this.trip,
  });

  String? typename;
  int? response;
  String? message;
  Trip? trip;

  factory AddTrip.fromJson(Map<String, dynamic>? json) => AddTrip(
        typename: json?["__typename"],
        response: json?["response"],
        message: json?["message"],
        trip: Trip.fromJson(json?["trip"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "response": response,
        "message": message,
        "trip": trip?.toJson(),
      };
}

class Trip {
  Trip({
    this.typename,
    this.id,
  });

  String? typename;
  String? id;

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        typename: json["__typename"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "id": id,
      };
}
