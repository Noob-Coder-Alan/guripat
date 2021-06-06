import 'package:flutter/material.dart';
import 'package:frontend/core/state/app_state.dart';
import 'package:frontend/models/ItemList.dart';

abstract class HomeScreenView {
  late AppState state;
  late Widget body;
  late String accessCode;
  late String generatedAccessCode;
  late var formKey;

  void onCodeSubmit(BuildContext context, String code);
  void onGenerateCode(BuildContext context);
  void setLocalAccessCode(String code);
  void setAppState(AppState state);
  void isCodeValid(BuildContext context, String code);
}
