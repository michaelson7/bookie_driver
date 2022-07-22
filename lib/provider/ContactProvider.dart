import 'package:graphql/src/core/query_result.dart';
import '../model/core/SkillsModel.dart';
import '../model/core/contactModel.dart';
import '../view/constants/mutations.dart';
import 'MutationProvider.dart';

class ContactProvider {
  Future<ContactModel> getContact() async {
    var response = ContactModel();
    var jsonBody = {
      "": "",
    };
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: contactDetails,
    );
    if (!data.hasException) {
      response = ContactModel.fromJson(data.data!);
    }
    return response;
  }
}
