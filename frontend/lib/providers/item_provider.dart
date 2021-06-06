import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/datasources/item/item_remote_datasource.dart';
import 'package:frontend/models/item.dart';
import 'package:frontend/models/new_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemProvider extends ChangeNotifier {
  List<Item> listItems = [];
  ItemRemoteDatasource datasource;
  Future<SharedPreferences> localStorageInstance;

  ItemProvider({required this.datasource, required this.localStorageInstance});

  
  Future<List<Item>> getItems() async {
    var localStorage = await localStorageInstance;
    var accessCode = localStorage.getString("accessCode")!;

    if(await datasource.checkConnection(accessCode)){
      var itemsResult = await datasource.getItems(accessCode);
      var sortedItems = sortByPerishable(itemsResult);

      localStorage.setString("items", encodeToString(sortedItems));
      listItems = sortedItems;

      return sortedItems;
    }

    var itemsFromLocal = decodeFromPrefs(localStorage.getString("items")!); 
    listItems = sortByPerishable(itemsFromLocal);
    return itemsFromLocal;
  }

  Future<bool> addItem(NewItem item) async {

    var localStorage = await localStorageInstance;
    var accessCode = localStorage.getString("accessCode")!;

    if(await datasource.checkConnection(accessCode)){
      var itemResult = await datasource.addItem(item: item, code: accessCode);
      var listString = json.decode(localStorage.getString("items")!);
      
      List<Item> items = decodeFromPrefs(listString);
      
      items.add(itemResult);
      var sortedItems = sortByPerishable(items);
      listItems = sortedItems;

      var encoded = encodeToString(sortedItems);

      localStorage.setString("items", encoded);

      return true; 
    }
    return false;
  }

  Future<bool> deleteItem(Item item) async {
    
    var localStorage = await localStorageInstance;
    var accessCode = localStorage.getString("accessCode")!;
    
    if(await datasource.checkConnection(accessCode)){
      var deleteResult = datasource.deleteItem(item: item, code: accessCode);

      var items = decodeFromPrefs(localStorage.getString("items")!);
      items.removeWhere((element) => element.id == item.id);

      var sortedItems = sortByPerishable(items);
      listItems = sortedItems;

      localStorage.setString('items', encodeToString(sortedItems));

      return deleteResult;
    }

    return false;
  }

  Future<bool> editItemQuantity(Item item) async {
    var localStorage = await localStorageInstance;
    var accessCode = localStorage.getString("accessCode")!;

    if(await datasource.checkConnection(accessCode)){
      var editResult = await datasource.editItemQuantity(item: item, code: accessCode);

      var items = decodeFromPrefs(localStorage.getString("items")!);
      var indexToUpdate = items.indexWhere((element) => element.id == editResult.id);
      items[indexToUpdate].quantity = editResult.quantity;

      listItems = items;

      localStorage.setString("items", encodeToString(items));
      return true;
    }
    return false;
  }

    Future<bool> markItemAsComplete(Item item) async {
    var localStorage = await localStorageInstance;
    var accessCode = localStorage.getString("accessCode")!;

    if(await datasource.checkConnection(accessCode)){
      var editResult = await datasource.markItemAsComplete(item: item, code: accessCode);

      var items = decodeFromPrefs(localStorage.getString("items")!);
      var indexToUpdate = items.indexWhere((element) => element.id == editResult.id);
      items[indexToUpdate].quantity = editResult.quantity;

      listItems = items;

      localStorage.setString("items", encodeToString(items));
      return true;
    }
    return false;
  }



  List<Item> decodeFromPrefs(String valueFromPrefs){
    List itemsDecoded = json.decode(valueFromPrefs);
    var decoded = itemsDecoded.map((item) => Item.fromJson(item)).toList();
    return decoded;
  }

  String encodeToString(List<Item> items){
    var mapList = items.map((e) => e.toJson()).toList();
    var encoded = json.encode(mapList);
    return encoded;
  }

  List<Item> sortByPerishable(List<Item> items){
    var perishables = items.where((element) => element.isPerishable).toList();
    var nonPerishables = items.where((element) => element.isPerishable == false).toList();

    var sortedList = [...nonPerishables, ...perishables];

    return sortedList;
  }
}

