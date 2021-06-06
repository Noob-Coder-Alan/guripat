// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/datasources/list/list_remote_datasource.dart';

import 'package:frontend/models/ItemList.dart';
import 'package:frontend/providers/list_provider.dart';
import 'package:mockito/mockito.dart';

class MockItemListRemoteDatasource extends Mock
    implements ItemListRemoteDatasource {
  @override
  Future<bool> checkConnection() async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> codeIsValid(String code) async {
    try {
      if ("abd443a5-6761-451f-af2f-5eaf1d8a21af" == code){
        return true;
      }
      return false;

    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteList(String code) async {
    try {

      if(code == "abd443a5-6761-451f-af2f-5eaf1d8a21af"){
        return true;
      } 
      return false;

    } catch (e) {
      return false;
    }
  }

  @override
  Future<ItemList> generateListCode() async {
    try {
      return ItemList(id: 1, code: "abd443a5-6761-451f-af2f-5eaf1d8a21af");
    } catch (e) {
      return ItemList(id: 0, code: "");
    }
  }
}


void main() {

  var datasource = MockItemListRemoteDatasource();
  var provider = ListProvider(datasource: datasource);
  
  test('List Provider should return a generated list code', () async {
    var generatedCode = await provider.generateListCode();
    expect(generatedCode.code, "abd443a5-6761-451f-af2f-5eaf1d8a21af");
  });

  test('List Provider should return true if a valid list code is passed', () async {
    var isValid = await provider.isCodeValid("abd443a5-6761-451f-af2f-5eaf1d8a21af");
    expect(isValid, true);
  });

  test('List Provider should return true if server is reachable', () async {
    var isReachable = await provider.checkConnection();
    expect(isReachable, true);
  });


  test('List Provider should be able to set list to list property', () async {
    provider.setAccessCode(1, "abd443a5-6761-451f-af2f-5eaf1d8a21af");
    expect(provider.list.code, "abd443a5-6761-451f-af2f-5eaf1d8a21af");
  });

  test('List Provider should be able to delete item list', () async {
    provider.deleteAccessCode();
    expect(provider.list.code, "");
  });

  test('List Provider should return true if a list is deleted successfully', () async {
    var isDeleted = await provider.deleteList("abd443a5-6761-451f-af2f-5eaf1d8a21af");
    expect(isDeleted, true);
  });

}
