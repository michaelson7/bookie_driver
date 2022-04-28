class SkillsModel {
  SkillsModel({
    this.typename,
    this.allSkills,
  });

  String? typename;
  List<AllSkill>? allSkills;

  factory SkillsModel.fromJson(Map<String, dynamic> json) => SkillsModel(
        typename: json["__typename"] == null ? null : json["__typename"],
        allSkills: json["allSkills"] == null
            ? null
            : List<AllSkill>.from(
                json["allSkills"].map((x) => AllSkill.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename == null ? null : typename,
        "allSkills": allSkills == null
            ? null
            : List<dynamic>.from(allSkills!.map((x) => x.toJson())),
      };
}

class AllSkill {
  AllSkill({
    this.typename,
    this.id,
    this.name,
  });

  String? typename;
  String? id;
  String? name;

  factory AllSkill.fromJson(Map<String, dynamic> json) => AllSkill(
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
