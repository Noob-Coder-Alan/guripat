import 'package:frontend/models/ItemList.dart';

abstract class IItemListDataSource {
  Future<bool> codeIsValid(String code);
}

abstract class IItemListRemoteDataSource implements IItemListDataSource {
  Future<ItemList> generateListCode();
  Future<bool> deleteList(String code);
  Future<bool> checkConnection();
}
