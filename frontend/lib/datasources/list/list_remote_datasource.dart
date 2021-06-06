import 'dart:convert';

import 'package:frontend/models/ItemList.dart';
import 'package:graphql/client.dart';

import 'list_datasource.dart';

class ItemListRemoteDatasource implements IItemListRemoteDataSource {
  GraphQLClient client;
  ItemListRemoteDatasource({required this.client});

  @override
  Future<bool> checkConnection() async {
    try {
      final query = """
      query {
        checkConnectionList()
      }
      """;
      final response = await client.query(
        QueryOptions(document: gql(query)),
      );

      var data = jsonEncode(response.data!['checkConnectionList']);
      return jsonDecode(data);
    } catch (e) {
      // print(e);
      return false;
    }
  }

  @override
  Future<bool> codeIsValid(String code) async {
    try {
      final query = """
      query {
        codeIsValid(accessCode: $code)
      }
      """;
      final response = await client.query(
        QueryOptions(document: gql(query)),
      );

      var data = jsonEncode(response.data!['codeIsValid']);
      return jsonDecode(data);
    } catch (e) {
      // print(e);
      return false;
    }
  }

  @override
  Future<bool> deleteList(String code) async {
    try {
      final query = """
      mutation {
        deleteList(accessCode: $code)
      }
      """;
      final response = await client.query(
        QueryOptions(document: gql(query)),
      );

      var data = jsonEncode(response.data!['deleteList']);
      return jsonDecode(data);
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<ItemList> generateListCode() async {
    try {
      final query = """
        mutation {
          generateListCode{
            id,
            code
          }
        }
      """;
      final response = await client.query(
        QueryOptions(document: gql(query)),
      );

      var data = jsonEncode(response.data!['generateListCode']);
      return ItemList.fromJson(jsonDecode(data));
    } catch (e) {
      print(e);
      return ItemList(id: 0, code: "");
    }
  }
}
