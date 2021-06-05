import 'package:flutter/material.dart';
import 'package:frontend/models/ItemList.dart';

class ListProvider extends ChangeNotifier {
  ItemList list = ItemList(id: 0, code: "");

  void setAccessCode(String code) {
    list.code = code;
  }

  void deleteAccessCode() {
    list.code = "";
  }
}
