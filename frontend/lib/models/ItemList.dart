class ItemList {
  int id;
  String code;

    ItemList({
    required this.id, 
    required this.code
  });

    factory ItemList.fromJson(Map<String, dynamic> listJson) {
    return ItemList(
        id: int.parse(listJson['id']),
        code: listJson['code']
    );
  }

  String toString() {
    return 'id: $id';
  }
}
