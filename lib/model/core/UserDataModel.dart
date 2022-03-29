class UserDataModel {
  UserDataModel({
    this.typename,
    this.me,
  });

  String? typename;
  Me? me;

  factory UserDataModel.fromJson(Map<String, dynamic>? json) => UserDataModel(
        typename: json?["__typename"],
        me: Me.fromJson(json?["me"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "me": me?.toJson(),
      };
}

class Me {
  Me({
    required this.typename,
    required this.pk,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.driverSet,
  });

  String typename;
  int pk;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  List<DriverSet> driverSet;

  factory Me.fromJson(Map<String, dynamic> json) => Me(
        typename: json["__typename"],
        pk: json["pk"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        driverSet: List<DriverSet>.from(
            json["driverSet"].map((x) => DriverSet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "pk": pk,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "driverSet": List<dynamic>.from(driverSet.map((x) => x.toJson())),
      };
}

class DriverSet {
  DriverSet({
    required this.typename,
    required this.active,
    required this.id,
  });

  String typename;
  bool active;
  String id;

  factory DriverSet.fromJson(Map<String, dynamic> json) => DriverSet(
        typename: json["__typename"],
        active: json["active"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "active": active,
        "id": id,
      };
}
