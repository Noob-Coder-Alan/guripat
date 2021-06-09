import 'package:flutter/material.dart';
import 'package:frontend/datasources/item/item_remote_datasource.dart';
import 'package:frontend/providers/item_provider.dart';
import 'package:frontend/providers/list_provider.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'datasources/list/list_remote_datasource.dart';
import 'features/home/screens/home_screen.dart';
import 'features/list/item_list_screen.dart';

void main() {
  // SharedPreferences _storage;
  WidgetsFlutterBinding.ensureInitialized();

  var link = 'http://localhost:5000/graphql';

  ItemListRemoteDatasource itemListDatasource = ItemListRemoteDatasource(
      client: GraphQLClient(cache: GraphQLCache(), link: HttpLink(link)));

  ItemRemoteDatasource itemDatasource = ItemRemoteDatasource(
      client: GraphQLClient(cache: GraphQLCache(), link: HttpLink(link)));

  var localStorageInstance = SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ItemProvider>(
          create: (_) => ItemProvider(
              localStorageInstance: localStorageInstance,
              datasource: itemDatasource),
        ),
        ChangeNotifierProvider<ListProvider>(
          create: (_) => ListProvider(
              localStorageInstance: localStorageInstance,
              datasource: itemListDatasource),
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
              cache: GraphQLCache()
            );
              return currentList.list.code == "" ?HomeScreen() : ListScreen();
          },
        )
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   var screenToShow;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Guripat',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: Consumer<ListProvider>(
//           builder: (context, currentList, child) {
//             currentList.datasource.client = GraphQLClient(
//                 link: HttpLink('http://localhost:5000/graphql'),
//                 cache: GraphQLCache());


//               return value ? ListScreen() : HomeScreen();
//           },
//         ));
//   }
// }
