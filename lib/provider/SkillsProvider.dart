import 'package:graphql/src/core/query_result.dart';
import '../model/core/SkillsModel.dart';
import '../view/constants/mutations.dart';
import 'MutationProvider.dart';

class SkillsProvider {
  Future<SkillsModel> allSkillsRequest() async {
    var response = SkillsModel();
    var jsonBody = {
      "": "",
    };
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: allSkills,
    );
    if (!data.hasException) {
      response = SkillsModel.fromJson(data.data!);
    }
    return response;
  }
}
