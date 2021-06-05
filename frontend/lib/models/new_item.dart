
class NewItem {
  String name;
  bool isPerishable;
  int quantity;

  NewItem({
    required this.name, 
    required this.isPerishable, 
    required this.quantity
  });


  String toString() {
    return 'name: $name, quantity: $quantity , isPerishable: $isPerishable';
  }
}
