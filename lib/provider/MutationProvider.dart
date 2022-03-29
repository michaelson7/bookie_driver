import 'dart:convert';

import 'package:bookie_driver/provider/shared_prefrence_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../view/constants/enum.dart';
import '../view/constants/mutations.dart';
import '../view/widgets/GraphQLConfiguration.dart';
import '../view/widgets/logger_widget.dart';
import '../view/widgets/toast.dart';
import 'RegistrationProvider.dart';

Mutation<dynamic> MutationProviderPro({
  required Function response,
  required mutation,
  required jsonBody,
  required child,
  required formKey,
  required BuildContext context,
}) {
  return Mutation(
    options: MutationOptions(
      document: gql(mutation),
      update: (GraphQLDataProxy cache, QueryResult? result) {
        return cache;
      },
      onCompleted: (dynamic resultData) async {
        Map responseValue = jsonDecode(jsonEncode(resultData));
        loggerAccent(message: "JSON RESPONSE: ${responseValue}");
        await response(responseValue);
      },
    ),
    builder: (
      RunMutation runMutation,
      QueryResult? result,
    ) {
      return InkWell(
        onTap: () async {
          if (formKey.currentState!.validate()) {
            toastMessage(context: context, message: "Uploading Data");
            loggerAccent(message: "JSON BODY: $jsonBody");
            runMutation(jsonBody);
          }
        },
        child: child,
      );
    },
  );
}

SharedPreferenceProvider _sp = SharedPreferenceProvider();

Future<QueryResult> MutationRequest({
  required mutation,
  required jsonBody,
}) async {
  try {
    var isTokenValid = await checkToken();
  } catch (e) {}

  var token = await _sp.getStringValue(
    getEnumValue(Token.token),
  );
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration(token);
  GraphQLClient client = graphQLConfiguration.clientToQuery(token);
  loggerAccent(message: "JSON BODY: $jsonBody");

  QueryResult queryResult = await client.query(
    QueryOptions(document: gql(mutation), variables: jsonBody),
  );
  var data = queryResult.data;
  var error = queryResult.exception;
  if (!queryResult.hasException) {
    loggerAccent(message: "JSON RESPONSE: ${jsonEncode(data)}");
  } else {
    loggerError(message: error.toString());
  }
  return queryResult;
}

checkToken() async {
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  var token = await _sp.getStringValue(
    getEnumValue(Token.token),
  );
  var refreshToken = await _sp.getStringValue(
    getEnumValue(Token.refreshToken),
  );
  var jsonBody = {
    "token": token,
  };

  loggerAccent(message: "CURRENT TOKEN: $token");
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration(token);
  GraphQLClient client = graphQLConfiguration.clientToQuery(token);

  QueryResult queryResult = await client.query(
    QueryOptions(document: gql(verifyToken), variables: jsonBody),
  );
  var data = queryResult.data;
  var response = data!["verifyToken"];
  if (response!["success"] == true) {
    loggerAccent(message: "TOKEN VALID");
  } else {
    loggerAccent(message: "TOKEN INVALID");
    //refresh token
    await refreshTokenRequest(refreshTokenValue: refreshToken);
  }
}

Future<Map<String, dynamic>> refreshTokenRequest({
  required refreshTokenValue,
}) async {
  var jsonBody = {
    "refreshToken": refreshTokenValue,
  };
  var token = await _sp.getStringValue(
    getEnumValue(Token.token),
  );
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration(token);
  GraphQLClient client = graphQLConfiguration.clientToQuery(token);

  QueryResult queryResult = await client.query(
    QueryOptions(document: gql(refreshToken), variables: jsonBody),
  );

  var responseBody = queryResult.data;
  var response = responseBody!["refreshToken"];
  bool responseVal = response["success"];
  if (responseVal) {
    await setToken(response);
  }
  return responseBody;
}

Future<void> setToken(response) async {
  var token = response["token"];
  var refreshToken = response["refreshToken"];
  if (token != null) {
    SharedPreferenceProvider _sp = SharedPreferenceProvider();
    await _sp.setString(
      key: getEnumValue(Token.token),
      value: token,
    );
    await _sp.setString(
      key: getEnumValue(Token.refreshToken),
      value: refreshToken,
    );
  }
}
