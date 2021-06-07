import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/datasources/item/item_remote_datasource.dart';
import 'package:frontend/datasources/list/list_remote_datasource.dart';

import 'package:frontend/models/ItemList.dart';
import 'package:frontend/models/item.dart';
import 'package:frontend/models/new_item.dart';
import 'package:frontend/providers/item_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockItemRemoteDatasource extends Mock implements ItemRemoteDatasource {
  List<Item> database = [
        Item(id: 1, name: "Rice 1 kilo", isPerishable: false, quantity: 5),
        Item(id: 2, name: "Beef 1 kilo", isPerishable: true, quantity: 10),
        Item(id: 3, name: "name", isPerishable: true, quantity: 25),
      ];

  Future<Item> addItem({required NewItem item, required String code}) async {
    try {
      if(code == "abd443a5-6761-451f-af2f-5eaf1d8a21af"){
        var newItem = Item(
          id: 4,
          isPerishable: item.isPerishable,
          quantity: item.quantity,
          name: item.name
        );

        database.add(newItem);
        return newItem;
      }
    } catch (e) {
      throw e;
    }
    return Item(id: 0,name: "", quantity: 0, isPerishable: false);
  }

  Future<List<Item>> getItems(String code) async {
    try {
      return database;
    } catch (e) {
      print("An error has because there is no internet connection!");
      throw e;
    }
  }

  Future<bool> deleteItem({required Item item, required String code}) async {
    try {
      database.removeWhere((element) => element.id == item.id);
      return true;
    } catch (e) {
      throw e;
    }
  }

   Future<Item> editItemQuantity(
      {required Item item, required String code}) async {
    try {
      var indexOfItem = database.indexWhere((element) => element.id == item.id);
      database[indexOfItem].quantity = item.quantity;
      return database[indexOfItem];
    } catch (e) {
      throw e;
    }
  }

    @override
  Future<Item> markItemAsComplete(
      {required Item item, required String code}) async {
    try {
      var indexOfItem = database.indexWhere((element) => element.id == item.id);
      database[indexOfItem].quantity = 0;
      return database[indexOfItem];
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
  var datasource = MockItemRemoteDatasource();
  SharedPreferences.setMockInitialValues({});
  var localStorageInstance = SharedPreferences.getInstance();
  var localStorage = await SharedPreferences.getInstance();
  localStorage.setString("accessCode", "abd443a5-6761-451f-af2f-5eaf1d8a21af");

  var provider = ItemProvider(
    datasource: datasource, 
    localStorageInstance: SharedPreferences.getInstance()
  );

  NewItem dummyNewItem = NewItem(isPerishable: true, quantity: 5, name: "1 Kilo tilapia");
  
  test('Item Provider should be able to add items to server and changes should reflect on localStorage and list item property', () async {
    var itemsBeforeAdd = await provider.getItems();

    expect(itemsBeforeAdd.indexWhere((element) => element.id == 4), -1);
    expect(provider.listItems.indexWhere((element) => element.id == 4), -1);
    expect(provider.decodeFromPrefs(localStorage.getString("items")!)
            .indexWhere((element) => element.id == 4) == -1, true);

    provider.addItem(dummyNewItem);
    var itemsAfterAdd = await provider.getItems();

    expect(itemsAfterAdd.indexWhere((element) => element.id == 4) != -1, true);
    expect(provider.listItems.indexWhere((element) => element.id == 4) != -1, true);
     expect(provider.decodeFromPrefs(localStorage.getString("items")!)
            .indexWhere((element) => element.id == 4) != -1, true);
  });

  test('Item provider should be able to delete items from server and changes should reflect on localStorage and list property', () async {
    var itemsBeforeDeletion = await provider.getItems();

    expect(itemsBeforeDeletion.indexWhere((element) => element.id == 4) != -1, true);
    expect(provider.listItems.indexWhere((element) => element.id == 4) != -1, true);
    expect(provider.decodeFromPrefs(localStorage.getString("items")!)
            .indexWhere((element) => element.id == 4) != -1, true);


    provider.deleteItem(Item(id: 4, quantity: dummyNewItem.quantity, isPerishable: dummyNewItem.isPerishable, name: dummyNewItem.name));
    var itemsAfterDeletion = await provider.getItems();

    expect(itemsAfterDeletion.indexWhere((element) => element.id == 4), -1);
    expect(provider.listItems.indexWhere((element) => element.id == 4), -1);
    expect(provider.decodeFromPrefs(localStorage.getString("items")!)
            .indexWhere((element) => element.id == 4) == -1, true);

  });

  test("Item Provider should be able to edit items to the server and changes should reflect on localStorage and list prop", () async {
    var itemsBeforeEdit = await provider.getItems();

    expect(itemsBeforeEdit.where((element) => element.id == 1).toList().first.quantity == 5, true);
    expect(provider.listItems.where((element) => element.id == 1).toList().first.quantity == 5, true);
    expect(provider.decodeFromPrefs(localStorage.getString("items")!).where((element) => element.id == 1).toList().first.quantity == 5, true);

    var isEdited = await provider.editItemQuantity(Item(id: 1, name: "Rice 1 Kilo", isPerishable: false, quantity: 10));
    expect(isEdited, true);

    var itemsAfterEdit = await provider.getItems();

    expect(itemsAfterEdit.where((element) => element.id == 1).toList().first.quantity == 10, true);
    expect(provider.listItems.where((element) => element.id == 1).toList().first.quantity == 10, true);
    expect(provider.decodeFromPrefs(localStorage.getString("items")!).where((element) => element.id == 1).toList().first.quantity == 10, true);
  });

    test("Item Provider should be able to change selected item quantity to zero to server and changes should reflect on localStorage and list prop", () async {
    var itemsBeforeEdit = await provider.getItems();

    expect(itemsBeforeEdit.where((element) => element.id == 1).toList().first.quantity == 10, true);
    expect(provider.listItems.where((element) => element.id == 1).toList().first.quantity == 10, true);
    expect(provider.decodeFromPrefs(localStorage.getString("items")!).where((element) => element.id == 1).toList().first.quantity == 10, true);

    var isComplete = await provider.markItemAsComplete(Item(id: 1, name: "Rice 1 Kilo", isPerishable: false, quantity: 10));
    expect(isComplete, true);

    var itemsAfterEdit = await provider.getItems();

    expect(itemsAfterEdit.where((element) => element.id == 1).toList().first.quantity == 0, true);
    expect(provider.listItems.where((element) => element.id == 1).toList().first.quantity == 0, true);
    expect(provider.decodeFromPrefs(localStorage.getString("items")!).where((element) => element.id == 1).toList().first.quantity == 0, true);
  });

    test("Provider's encodeToString method should return a 'stringified' list of Item json", (){
    var stringifiedDatabase = '[{"id":1,"name":"Rice 1 kilo","isPerishable":false,"quantity":5}]';
    var database = [
      Item(id: 1, name: "Rice 1 kilo", isPerishable: false, quantity: 5),
    ];
    var stringified = provider.encodeToString(database);
    expect(stringified, stringifiedDatabase);
  });

  test("Provider's decodeFromPrefs method should return a list of Item objects given a 'stringified' list of json with Item Object properties and values", (){
    var database = [
        Item(id: 1, name: "Rice 1 kilo", isPerishable: false, quantity: 5),
        Item(id: 2, name: "Beef 1 kilo", isPerishable: true, quantity: 10),
      ];

    var stringifiedDatabase = provider.encodeToString(database);

    var decoded = provider.decodeFromPrefs(stringifiedDatabase);
    expect(decoded.length, database.length);
    expect(decoded.first.id, database.first.id);
    expect(decoded.last.id, database.last.id);
  });

  test("Provider's sortByPerishables should return a sorted list of items with perishables first and nonperishables last", (){
    var database = [
        Item(id: 1, name: "Rice 1 kilo", isPerishable: false, quantity: 5),
        Item(id: 2, name: "Beef 1 kilo", isPerishable: true, quantity: 10),
        Item(id: 3, name: "Pork 1 kilo", isPerishable: true, quantity: 10),
      ];

    var sorted = provider.sortByPerishable(database);

    expect(sorted.first.isPerishable, true);
    expect(sorted[1].isPerishable, true);
    expect(sorted.last.isPerishable, false);
  });

  
}