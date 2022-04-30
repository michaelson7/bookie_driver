class UserDataModel {
  UserDataModel({
    required this.typename,
    this.me,
  });

  String typename;
  Me? me;

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        typename: json["__typename"] == null ? null : json["__typename"],
        me: json["me"] == null ? null : Me.fromJson(json["me"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "me": me == null ? null : me?.toJson(),
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
    required this.isActive,
    this.profilepictureSet,
    this.driverSet,
  });

  String typename;
  int pk;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  bool isActive;
  List<ProfilepictureSet>? profilepictureSet;
  List<DriverSet>? driverSet;

  factory Me.fromJson(Map<String, dynamic> json) => Me(
        typename: json["__typename"] == null ? null : json["__typename"],
        pk: json["pk"] == null ? null : json["pk"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        email: json["email"] == null ? null : json["email"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        isActive: json["isActive"] == null ? null : json["isActive"],
        profilepictureSet: json["profilepictureSet"] == null
            ? null
            : List<ProfilepictureSet>.from(json["profilepictureSet"]
                .map((x) => ProfilepictureSet.fromJson(x))),
        driverSet: json["driverSet"] == null
            ? null
            : List<DriverSet>.from(
                json["driverSet"].map((x) => DriverSet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "pk": pk == null ? null : pk,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "email": email == null ? null : email,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "isActive": isActive == null ? null : isActive,
        "profilepictureSet": profilepictureSet == null
            ? null
            : List<dynamic>.from(profilepictureSet!.map((x) => x.toJson())),
        "driverSet": driverSet == null
            ? null
            : List<dynamic>.from(driverSet!.map((x) => x.toJson())),
      };
}

class DriverSet {
  DriverSet({
    required this.typename,
    required this.active,
    required this.id,
    this.skills,
    this.drivervehicleSet,
  });

  String typename;
  bool active;
  String id;
  List<Skill>? skills;
  List<DrivervehicleSet>? drivervehicleSet;

  factory DriverSet.fromJson(Map<String, dynamic> json) => DriverSet(
        typename: json["__typename"] == null ? null : json["__typename"],
        active: json["active"] == null ? null : json["active"],
        id: json["id"] == null ? null : json["id"],
        skills: json["skills"] == null
            ? null
            : List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
        drivervehicleSet: json["drivervehicleSet"] == null
            ? null
            : List<DrivervehicleSet>.from(json["drivervehicleSet"]
                .map((x) => DrivervehicleSet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "active": active == null ? null : active,
        "id": id == null ? null : id,
        "skills": skills == null
            ? null
            : List<dynamic>.from(skills!.map((x) => x.toJson())),
        "drivervehicleSet": drivervehicleSet == null
            ? null
            : List<dynamic>.from(drivervehicleSet!.map((x) => x.toJson())),
      };
}

class DrivervehicleSet {
  DrivervehicleSet({
    required this.typename,
    required this.registrationPlate,
    required this.modelName,
    required this.modelColor,
    required this.image,
  });

  String typename;
  String registrationPlate;
  String modelName;
  String modelColor;
  String? image;

  factory DrivervehicleSet.fromJson(Map<String, dynamic> json) =>
      DrivervehicleSet(
        typename: json["__typename"] == null ? null : json["__typename"],
        registrationPlate: json["registrationPlate"] == null
            ? null
            : json["registrationPlate"],
        modelName: json["modelName"] == null ? null : json["modelName"],
        modelColor: json["modelColor"] == null ? null : json["modelColor"],
        image: json["image"] == null
            ? null
            : "https://bookie-media.s3.af-south-1.amazonaws.com/" +
                json["image"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "registrationPlate":
            registrationPlate == null ? null : registrationPlate,
        "modelName": modelName == null ? null : modelName,
        "modelColor": modelColor == null ? null : modelColor,
        "image": image == null ? null : image,
      };
}

class Skill {
  Skill({
    required this.typename,
    required this.name,
  });

  String typename;
  String name;

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        typename: json["__typename"] == null ? null : json["__typename"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "name": name == null ? null : name,
      };
}

class ProfilepictureSet {
  ProfilepictureSet({
    required this.typename,
    required this.image,
  });

  String typename;
  String? image;

  factory ProfilepictureSet.fromJson(Map<String, dynamic> json) =>
      ProfilepictureSet(
        typename: json["__typename"] == null ? null : json["__typename"],
        image: json["image"] == null
            ? null
            : "https://bookie-media.s3.af-south-1.amazonaws.com/" +
                json["image"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "image": image == null ? null : image,
      };
}
