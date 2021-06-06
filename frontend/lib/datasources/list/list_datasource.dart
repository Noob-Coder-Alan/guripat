import 'package:frontend/models/ItemList.dart';
import 'package:frontend/models/item.dart';
import 'package:frontend/models/new_item.dart';

abstract class IItemListDataSource {
  Future<bool> codeIsValid(String code);
}

abstract class IItemListRemoteDataSource implements IItemListDataSource {
  Future<ItemList> generateListCode();
  Future<bool> deleteList(String code);
  Future<bool> checkConnection();
}
