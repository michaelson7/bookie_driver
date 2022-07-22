class ContactModel {
  ContactModel({
    this.typename,
    this.contactDetails,
  });

  String? typename;
  List<ContactDetail>? contactDetails;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        typename: json["__typename"] == null ? null : json["__typename"],
        contactDetails: json["contactDetails"] == null
            ? null
            : List<ContactDetail>.from(
                json["contactDetails"].map((x) => ContactDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "contactDetails": contactDetails == null
            ? null
            : List<dynamic>.from(contactDetails!.map((x) => x.toJson())),
      };
}

class ContactDetail {
  ContactDetail({
    required this.typename,
    required this.description,
    required this.email,
    required this.phone,
    required this.address,
  });

  String typename;
  String description;
  String email;
  String phone;
  String address;

  factory ContactDetail.fromJson(Map<String, dynamic> json) => ContactDetail(
        typename: json["__typename"] == null ? null : json["__typename"],
        description: json["description"] == null ? null : json["description"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        address: json["address"] == null ? null : json["address"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "description": description == null ? null : description,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "address": address == null ? null : address,
      };
}
