import 'package:frontend/models/item.dart';
import 'package:frontend/models/new_item.dart';

abstract class IItemDataSource {
  Future<List<Item>> getItems(String code);
}

abstract class IItemRemoteDataSource implements IItemDataSource {
  Future<Item> addItem({required NewItem item, required String code});
  Future<bool> deleteItem({required Item item, required String code});
  Future<Item> editItemQuantity({required Item item, required String code});
  Future<Item> markItemAsComplete({required Item item, required String code});
  Future<bool> checkConnection(String code);
}
