class DriverResponseModel {
  DriverResponseModel({
    this.typename,
    this.createDriver,
  });

  String? typename;
  CreateDriver? createDriver;

  factory DriverResponseModel.fromJson(Map<String, dynamic> json) =>
      DriverResponseModel(
        typename: json["__typename"] == null ? null : json["__typename"],
        createDriver: json["createDriver"] == null
            ? null
            : CreateDriver.fromJson(json["createDriver"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "createDriver": createDriver == null ? null : createDriver!.toJson(),
      };
}

class CreateDriver {
  CreateDriver({
    required this.typename,
    required this.response,
    required this.message,
  });

  String typename;
  int response;
  String message;

  factory CreateDriver.fromJson(Map<String, dynamic> json) => CreateDriver(
        typename: json["__typename"] == null ? null : json["__typename"],
        response: json["response"] == null ? null : json["response"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "response": response == null ? null : response,
        "message": message == null ? null : message,
      };
}
