import 'dart:convert';

import 'package:frontend/models/item.dart';
import 'package:frontend/models/new_item.dart';
import 'package:graphql/client.dart';

import 'item_datasource.dart';

class ItemRemoteDatasource implements IItemRemoteDataSource {
  GraphQLClient client;
  ItemRemoteDatasource({required this.client});

  @override
  Future<Item> addItem({required NewItem item, required String code}) async {
    try {
      final query = """
        mutation {
          addItem(accessCode: "${code}", isPerishable: ${item.isPerishable}, quantity: ${item.quantity}, name: "${item.name}"){
            id,
            name,
            quantity,
            isPerishable,
          }
        }
      """;

      final response = await client.query(
        QueryOptions(document: gql(query)),
      );

      var data = jsonEncode(response.data!['addItem']);
      return Item.fromJson(jsonDecode(data));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Item>> getItems(String code) async {
    try {
      final query = """
        query {
          getItems(accessCode: "$code"){
            id,
            name,
            quantity,
            isPerishable,
          }
        }
      """;

      final response = await client.query(
        QueryOptions(document: gql(query)),
      );

      var data = jsonEncode(response.data!['getItems']);
      print(data);
      var decoded = await jsonDecode(data)
          .map<Item>((item) => Item.fromJson(item))
          .toList();

      return decoded;
    } catch (e) {
      print("An error has because there is no internet connection!");
      throw e;
    }
  }

  @override
  Future<bool> deleteItem({required Item item, required String code}) async {
    try {
      final query = """
        mutation {
          deleteItem(itemId: ${item.id}, accessCode: "$code")
        }
      """;

      final response = await client.query(
        QueryOptions(document: gql(query)),
      );

      var data = jsonEncode(response.data!['deleteItem']);
      return jsonDecode(data);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Item> editItemQuantity(
      {required Item item, required String code}) async {
    try {
      final query = """
      mutation {
        editItemQuantity(accessCode: "$code", itemId: ${item.id}, quantity: ${item.quantity}){
          id,
          name,
          quantity,
          isPerishable
        }
      }
      """;

      final response = await client.query(
        QueryOptions(document: gql(query)),
      );

      var data = jsonEncode(response.data!['editItemQuality']);
      return Item.fromJson(jsonDecode(data));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Item> markItemAsComplete(
      {required Item item, required String code}) async {
    try {
      final query = """
      mutation {
        markItemAsComplete(accessCode: "$code", itemId: ${item.id}){
          id,
          name,
          quantity,
          isPerishable
        }
      }
      """;

      final response = await client.query(
        QueryOptions(document: gql(query)),
      );

      var data = jsonEncode(response.data!['markItemAsComplete']);
      return Item.fromJson(jsonDecode(data));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> checkConnection(String code) async {
    try {
      final query = """
      mutation {
        checkConnection(accessCode: "$code")
      }
      """;
      final response = await client.query(
        QueryOptions(document: gql(query)),
      );

      var data = jsonEncode(response.data!['checkConnection']);
      return jsonDecode(data);
    } catch (e) {
      // print(e);
      return false;
    }
  }
}
