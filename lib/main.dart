import 'package:bookie_driver/view/screens/init/routes_init.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'view/widgets/GraphQLConfiguration.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration("");

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GraphQLProvider(
      client: graphQLConfiguration.client,
      child: RoutesInit(),
    ),
  );
}
