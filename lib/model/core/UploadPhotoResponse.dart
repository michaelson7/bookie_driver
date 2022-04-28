class UploadPhotoResponse {
  UploadPhotoResponse({
    this.typename,
    this.uploadProfilePicture,
  });

  String? typename;
  UploadProfilePicture? uploadProfilePicture;

  factory UploadPhotoResponse.fromJson(Map<String, dynamic> json) =>
      UploadPhotoResponse(
        typename: json["__typename"] == null ? null : json["__typename"],
        uploadProfilePicture: json["uploadProfilePicture"] == null
            ? null
            : UploadProfilePicture.fromJson(json["uploadProfilePicture"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "uploadProfilePicture": uploadProfilePicture == null
            ? null
            : uploadProfilePicture!.toJson(),
      };
}

class UploadProfilePicture {
  UploadProfilePicture({
    this.typename,
    this.success,
    this.profilePicture,
  });

  String? typename;
  bool? success;
  ProfilePicture? profilePicture;

  factory UploadProfilePicture.fromJson(Map<String, dynamic> json) =>
      UploadProfilePicture(
        typename: json["__typename"] == null ? null : json["__typename"],
        success: json["success"] == null ? null : json["success"],
        profilePicture: json["profilePicture"] == null
            ? null
            : ProfilePicture.fromJson(json["profilePicture"]),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "success": success == null ? null : success,
        "profilePicture":
            profilePicture == null ? null : profilePicture!.toJson(),
      };
}

class ProfilePicture {
  ProfilePicture({
    this.typename,
    this.image,
  });

  String? typename;
  String? image;

  factory ProfilePicture.fromJson(Map<String, dynamic> json) => ProfilePicture(
        typename: json["__typename"] == null ? null : json["__typename"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "image": image == null ? null : image,
      };
}
