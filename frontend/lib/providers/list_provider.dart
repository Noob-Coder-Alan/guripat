import 'package:flutter/material.dart';
import 'package:frontend/datasources/list/list_remote_datasource.dart';
import 'package:frontend/models/ItemList.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ListProvider extends ChangeNotifier {
  ItemList list = ItemList(id: 0, code: "");
  
  ItemListRemoteDatasource datasource = ItemListRemoteDatasource(
    client: GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink("http://localhost:5000/graphql")
    )
  );

  void setAccessCode(int id, String code) {
    list.code = code;
    list.id = id;
    notifyListeners();
  }

  void deleteAccessCode() {
    list.code = "";
    list.id = 0;
    notifyListeners();
  }

  Future<bool> checkConnection() async {
    var isConnected = await datasource.checkConnection();
    return isConnected;
  }

  Future<bool> isCodeValid(String code) async {
    var isValid = await datasource.checkConnection();
    notifyListeners();
    return isValid;
  }

  Future<bool> deleteList(String code) async {
    var isDeleted = await datasource.deleteList(code);
    return isDeleted;
  }

  Future<ItemList> generateListCode() async {
    var list = await datasource.generateListCode();
    return list;
  }
}
