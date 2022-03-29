import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  static var token;

  GraphQLConfiguration(tokenValue) {
    token = tokenValue;
  }

  static HttpLink httpLink = HttpLink(
    'https://api.bookierides.com',
    defaultHeaders: {
      'Authorization': 'jwt $token()',
    },
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
    ),
  );

  GraphQLClient clientToQuery(tokenValue) {
    HttpLink httpLinkPro = HttpLink(
      'https://api.bookierides.com',
      defaultHeaders: {
        'Authorization': 'jwt $tokenValue()',
      },
    );
    return GraphQLClient(
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
      link: httpLinkPro,
    );
  }
}
