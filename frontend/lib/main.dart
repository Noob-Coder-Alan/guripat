import 'package:flutter/material.dart';
import 'package:frontend/providers/item_provider.dart';
import 'package:frontend/providers/list_provider.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'datasources/list/list_remote_datasource.dart';
import 'features/home/screens/home_screen.dart';
import 'features/list/item_list_screen.dart';

void main() {
  // SharedPreferences _storage;
  WidgetsFlutterBinding.ensureInitialized();

  var link = 'http://localhost:5000/graphql';

  ItemListRemoteDatasource datasource = ItemListRemoteDatasource(
      client: GraphQLClient(cache: GraphQLCache(), link: HttpLink(link)));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ItemProvider>(
          create: (_) => ItemProvider(),
        ),
        ChangeNotifierProvider<ListProvider>(
          create: (_) => ListProvider(datasource: datasource),
        ),
      ],
      builder: (context, child) {
        return MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Guripat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<ListProvider>(
          builder: (context, currentList, child) {
            currentList.datasource.client = GraphQLClient(
                link: HttpLink('http://localhost:5000/graphql'),
                cache: GraphQLCache());
            return currentList.list.code == "" ? HomeScreen() : ListScreen();
          },
        ));
  }
}
