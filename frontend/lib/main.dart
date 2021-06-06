import 'package:flutter/material.dart';
import 'package:frontend/models/item.dart';
import 'package:frontend/models/new_item.dart';
import 'package:frontend/providers/item_provider.dart';
import 'package:frontend/providers/list_provider.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'datasources/item/item_remote_datasource.dart';
import 'datasources/list/list_remote_datasource.dart';
import 'features/home/screens/home_screen.dart';
import 'features/list/item_list_screen.dart';

void main() {

    SharedPreferences _storage;

  var httpLink = HttpLink('http://localhost:5000/graphql');

  var client = GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  );

    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ItemProvider>(
          create: (_) => ItemProvider(),
        ),
        ChangeNotifierProvider<ListProvider>(
          create: (_) => ListProvider(),
        ),
      ],
      builder: (context, child) {
        return MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<ListProvider>(
        builder: (context, currentList, child){
          return currentList.list.code == "" ? HomeScreen() : ListScreen();
        },
      ) 
    );
  }
}
