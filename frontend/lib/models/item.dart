
class Item {
  int id;
  String name;
  bool isPerishable;
  int quantity;

  Item({
    required this.id, 
    required this.name, 
    required this.isPerishable, 
    required this.quantity
  });

    factory Item.fromJson(Map<String, dynamic> itemJson) {
    return Item(
        id: itemJson['id'].runtimeType == int ? itemJson['id'] : int.parse(itemJson['id']),
        name: itemJson['name'],
        isPerishable: itemJson['isPerishable'],
        quantity: itemJson['quantity']
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'id' : id,
        'name': name,
        'isPerishable': isPerishable,
        'quantity': quantity
      };
    }

  String toString() {
    return 'id: $id, name: $name, quantity: $quantity , isPerishable: $isPerishable';
  }
}
