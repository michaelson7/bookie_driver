class ForgotPasswordResponse {
  ForgotPasswordResponse({
    this.typename,
    this.responseBody,
  });

  String? typename;
  Body? responseBody;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponse(
        typename: json["__typename"] == null ? null : json["__typename"],
        responseBody: json["forgotPassword"] == null
            ? null
            : Body.fromJson(json["forgotPassword"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "forgotPassword": responseBody == null ? null : responseBody?.toJson(),
      };
}

class Body {
  Body({
    this.typename,
    this.response,
    this.message,
  });

  String? typename;
  int? response;
  String? message;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
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
