import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {

  final httpLink = HttpLink(
    uri: 'https://tpja3lm5be.execute-api.us-east-1.amazonaws.com/dev/graphql',
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
          cache: InMemoryCache(),
          link: httpLink as Link
      )
  );

  String coffeeDrinks = """
    query {
      coffeeDrinks {
        name
      }
    }
  """;

  Widget testQuery = Query(
    options: QueryOptions(
      document: coffeeDrinks,
    ),
    builder: (QueryResult result, { VoidCallback refetch }) {
      if (result.errors != null) {
        return Text(result.errors.toString());
      }

      if (result.loading) {
        return Text('Loading...');
      }

      print('GraphQL response body: ${result.data}');
      List drinks = result.data['coffeeDrinks'];

      return ListView.builder(
          itemCount: drinks.length,
          itemBuilder: (context, index) {
            final drink = drinks[index];

            return Text(drink['name']);
          });
    },
  );

  runApp(
    GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: "Hello Coffee",
          home: Scaffold(
              appBar: AppBar(
                title: Text("Hello Coffee"),
              ),
              body: testQuery
          ),
        ),
      ),
    ),
  );
}
