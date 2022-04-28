class CarTypeModel {
  CarTypeModel({
    this.typename,
    this.allVehicleClass,
  });

  String? typename;
  List<AllVehicleClass>? allVehicleClass;

  factory CarTypeModel.fromJson(Map<String, dynamic> json) => CarTypeModel(
        typename: json["__typename"] == null ? null : json["__typename"],
        allVehicleClass: json["allVehicleClass"] == null
            ? null
            : List<AllVehicleClass>.from(json["allVehicleClass"]
                .map((x) => AllVehicleClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "allVehicleClass": allVehicleClass == null
            ? null
            : List<dynamic>.from(allVehicleClass!.map((x) => x.toJson())),
      };
}

class AllVehicleClass {
  AllVehicleClass({
    required this.typename,
    required this.id,
    required this.name,
  });

  String typename;
  String id;
  String name;

  factory AllVehicleClass.fromJson(Map<String, dynamic> json) =>
      AllVehicleClass(
        typename: json["__typename"] == null ? null : json["__typename"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
