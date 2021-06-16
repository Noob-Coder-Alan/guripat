import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/datasources/item/item_remote_datasource.dart';
import 'package:frontend/datasources/list/list_remote_datasource.dart';
import 'package:frontend/features/list/item_list_screen.dart';
import 'package:frontend/features/list/widgets/item_tile.dart';
import 'package:frontend/models/item.dart';
import 'package:frontend/models/new_item.dart';
import 'package:frontend/providers/item_provider.dart';
import 'package:frontend/providers/list_provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class MockItemListRemoteDatasource extends Mock implements ItemListRemoteDatasource {

// }

class MockItemRemoteDatasource extends Mock implements ItemRemoteDatasource {
  List<Item> items = [
    Item(id: 1, isPerishable: false, name: "1 Kilo Tilapia", quantity: 10),
    Item(id: 2, isPerishable: false, name: "1 Kilo Rice2", quantity: 10),
    Item(id: 3, isPerishable: false, name: "1 Kilo Rice3", quantity: 10),
  ];

  GraphQLClient client =
      GraphQLClient(link: HttpLink("FakeLink.com"), cache: GraphQLCache());

  @override
  Future<Item> addItem({required NewItem item, required String code}) async {
    try {
      items.add(
          Item(id: 4, isPerishable: false, name: "1 Kilo Rice4", quantity: 10));
      print("item has been added");
      return Item(
          id: 4, isPerishable: false, name: "1 Kilo Rice4", quantity: 10);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Item>> getItems(String code) async {
    try {
      return items;
    } catch (e) {
      print("An error has because there is no internet connection!");

      throw e;
    }
  }

  @override
  Future<bool> deleteItem({required Item item, required String code}) async {
    try {
      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Item> editItemQuantity(
      {required Item item, required String code}) async {
    try {
      return Item(
          id: 1, name: "1 Kilo Rice", isPerishable: false, quantity: 20);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Item> markItemAsComplete(
      {required Item item, required String code}) async {
    try {
      return Item(id: 1, name: "1 Kilo Rice", isPerishable: false, quantity: 0);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> checkConnection(String code) async {
    try {
      return true;
    } catch (e) {
      // print(e);
      return false;
    }
  }
}

void main() async {
  testWidgets('Item should be added to list after adding', (tester) async {
    SharedPreferences.setMockInitialValues(
        {"accessCode": "f174f56f-5d3a-49d8-a1b3-6be1e32ee081", "items": "[]"});

    var localStorageInstance = SharedPreferences.getInstance();
    var itemDatasource = MockItemRemoteDatasource();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ItemProvider>(
            create: (_) => ItemProvider(
                localStorageInstance: localStorageInstance,
                datasource: itemDatasource),
          ),
        ],
        builder: (context, child) {
          return MaterialApp(home: ListScreen());
        },
      ),
    );

    await tester.pumpAndSettle();

    final addButton = find.byKey(Key('addButton'));
    final itemListTile = find.byKey(Key("itemListTile"));
    expect(addButton, findsOneWidget);
    expect(itemListTile, findsNWidgets(3));

    await tester.tap(addButton);
    await tester.pump();

    final addDialog = find.byKey(Key('addDialog'));
    final buttonSubmit = find.widgetWithText(TextButton, 'Submit');
    final buttonCancel = find.widgetWithText(TextButton, 'Cancel');

    final nameField = find.byKey(Key('name'));
    final quantity = find.byKey(Key('quantity'));

    expect(addDialog, findsOneWidget);
    expect(buttonSubmit, findsOneWidget);
    expect(buttonCancel, findsOneWidget);
    expect(nameField, findsOneWidget);
    expect(quantity, findsOneWidget);

    await tester.enterText(nameField, "1 Kilo Rice");
    await tester.enterText(quantity, "10");
    await tester.tap(buttonSubmit);

    await tester.pumpAndSettle();

    expect(addDialog, findsNothing);
    expect(itemListTile, findsNWidgets(4));
  });
}
