import 'package:flutter/material.dart';
import 'package:frontend/core/state/app_state.dart';
import 'package:frontend/models/ItemList.dart';

abstract class HomeScreenView {
  late AppState state;
  late Widget body;

  Future<bool> onCodeSubmit(BuildContext context, String code);
  Future<ItemList> onGenerateCode(BuildContext context);
}