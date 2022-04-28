class ResetPasswordResponse {
  ResetPasswordResponse({
    this.typename,
    this.resetPassword,
  });

  String? typename;
  ResetPassword? resetPassword;

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ResetPasswordResponse(
        typename: json["__typename"] == null ? null : json["__typename"],
        resetPassword: json["resetPassword"] == null
            ? null
            : ResetPassword.fromJson(json["resetPassword"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "resetPassword": resetPassword == null ? null : resetPassword?.toJson(),
      };
}

class ResetPassword {
  ResetPassword({
    this.typename,
    this.response,
    this.message,
  });

  String? typename;
  int? response;
  String? message;

  factory ResetPassword.fromJson(Map<String, dynamic> json) => ResetPassword(
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
