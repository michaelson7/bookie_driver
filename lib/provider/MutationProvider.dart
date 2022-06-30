import 'dart:convert';
import 'dart:io';

import 'package:bookie_driver/provider/shared_prefrence_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../main.dart';
import '../view/constants/constants.dart';
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
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //loggerError(message: "NO INTERNET");
    }
  } on SocketException catch (_) {
    var width = MediaQuery.of(navigatorKey.currentState!.context).size.width;
    showDialog<void>(
        context: navigatorKey.currentState!.context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kAccent,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Container(
              width: width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kAccent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(365)),
                            color: Colors.yellow,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              MaterialIcons.signal_wifi_off,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: kBorderRadiusCircular,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            'No Internet Connection',
                            style: kTextStyleHeader2,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Please check your internet connection",
                            style: kTextStyleHint,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: kBorderRadiusCircularPro,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Retry",
                                        textAlign: TextAlign.center,
                                        style: kTextStyleWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

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
