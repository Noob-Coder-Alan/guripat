import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/datasources/list/list_remote_datasource.dart';
import 'package:frontend/models/ItemList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListProvider extends ChangeNotifier {
  ItemList list = ItemList(id: 0, code: "");
  ItemListRemoteDatasource datasource;
  Future<SharedPreferences> localStorageInstance;

  ListProvider({required this.datasource, required this.localStorageInstance});

  void setAccessCode(int id, String code) async {
      list.code = code;
      list.id = id;

      var localStorage = await localStorageInstance;
      await localStorage.setString("accessCode", code);
      
      var jsonString = json.encode([]);
      await localStorage.setString("items", jsonString);
      
    notifyListeners();
  }

  void deleteAccessCode() async {
    list.code = "";
    list.id = 0;

    var localStorage = await SharedPreferences.getInstance();
    localStorage.remove("accessCode");
    notifyListeners();
  }

  Future<bool> checkConnection() async {
    var isConnected = datasource.checkConnection();
    return isConnected;
  }

  Future<bool> isCodeValid(String code) async {
    if (await datasource.checkConnection()) {
      var isValid = await datasource.codeIsValid(code);
      return isValid;
    } else {
      return false;
    }
  }

  Future<bool> deleteList(String code) async {
    var isDeleted = await datasource.deleteList(code);
    this.deleteAccessCode();
    notifyListeners();
    return isDeleted;
  }

  Future<ItemList> generateListCode() async {
    var list = await datasource.generateListCode();
    notifyListeners();
    return list;
  }
}
