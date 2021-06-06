import 'package:flutter/material.dart';
import 'package:frontend/core/state/app_state.dart';
import 'package:frontend/features/home/presenters/home_screen_presenter.dart';
import 'package:frontend/features/home/screens/pages/home_view.dart';
import 'package:frontend/features/home/views/home_screen_view.dart';
import 'package:frontend/models/ItemList.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeScreenView {

  late HomeScreenPresenter presenter;

  @override
  late Widget body;

  @override
  late AppState state;


  @override
  void initState(){
    presenter = HomeScreenPresenter();
    presenter.attachView(this);
    
    state = AppState.done;
    body = Home(onSubmit: onCodeSubmit);


    super.initState();
  }

  @override
  Future<bool> onCodeSubmit(BuildContext context, String code) {
    // TODO: implement onCodeSubmit
    throw UnimplementedError();
  }

  @override
  Future<ItemList> onGenerateCode(BuildContext context) {
    // TODO: implement onGenerateCode
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guripat"),
      ),
      body: Container(),
    );
  }

}