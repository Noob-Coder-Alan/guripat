import 'package:flutter/material.dart';
import 'package:frontend/datasources/list/list_remote_datasource.dart';
import 'package:frontend/models/ItemList.dart';

class ListProvider extends ChangeNotifier {
  ItemList list = ItemList(id: 0, code: "");
  ItemListRemoteDatasource datasource;

  ListProvider({required this.datasource});

  void setAccessCode(int id, String code) async {
    if (await datasource.codeIsValid(code)) {
      list.code = code;
      list.id = id;
    }
    notifyListeners();
  }

  void deleteAccessCode() {
    list.code = "";
    list.id = 0;
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
    return isDeleted;
  }

  Future<ItemList> generateListCode() async {
    var list = await datasource.generateListCode();
    notifyListeners();
    return list;
  }
}
