import 'package:flutter/material.dart';
import 'package:frontend/core/state/app_state.dart';
import 'package:frontend/features/home/presenters/home_screen_presenter.dart';
import 'package:frontend/features/home/screens/pages/home_view.dart';
import 'package:frontend/features/home/views/home_screen_view.dart';
import 'package:frontend/providers/list_provider.dart';
import 'package:provider/provider.dart';

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
  late String accessCode;

  @override
  var formKey;

  @override
  late String generatedAccessCode;

  @override
  void initState() {
    presenter = HomeScreenPresenter();
    presenter.attachView(this);
    formKey = GlobalKey<FormState>();
    accessCode = "";
    generatedAccessCode = "";

    state = AppState.done;
    body = Home(
      onSubmit: onCodeSubmit,
      onGenerate: onGenerateCode,
      onAccessCodeSaved: setLocalAccessCode,
      accessCode: accessCode,
      formKey: formKey,
      generatedAccessCode: accessCode,
    );

    super.initState();
  }

  @override
  void onCodeSubmit(BuildContext context, String code) async {
    setState(() {
      state = AppState.loading;
    });

    var listProvider = Provider.of<ListProvider>(context, listen: false);

    var connection = await listProvider.checkConnection();
    var codeIsValid = await listProvider.isCodeValid(code);

    if (connection && codeIsValid) {
      listProvider.setAccessCode(0, code);
      setState(() {
        body = Home(
          onSubmit: onCodeSubmit,
          onGenerate: onGenerateCode,
          accessCode: accessCode,
          formKey: formKey,
          generatedAccessCode: generatedAccessCode,
          onAccessCodeSaved: setLocalAccessCode,
        );
        state = AppState.done;
      });
    } else {
      setState(() {
        body = Home(
          onSubmit: onCodeSubmit,
          onGenerate: onGenerateCode,
          accessCode: accessCode,
          formKey: formKey,
          generatedAccessCode: generatedAccessCode,
          onAccessCodeSaved: setLocalAccessCode,
        );
        state = AppState.invalid;
      });
    }
  }

  @override
  void onGenerateCode(BuildContext context) async {


    setState(() {
      state = AppState.loading;
    });

    var listProvider = Provider.of<ListProvider>(context, listen: false);

    


    if (await listProvider.checkConnection()) {
      var list = await listProvider.generateListCode();
      // print("list");
      // print(list.code);
      setState(() {
        generatedAccessCode = list.code;
        body = Home(
          onSubmit: onCodeSubmit,
          onGenerate: onGenerateCode,
          accessCode: accessCode,
          formKey: formKey,
          generatedAccessCode: generatedAccessCode,
          onAccessCodeSaved: setLocalAccessCode,
        );
        state = AppState.done;
      });
    } else {
      setState(() {
        state = AppState.error;
      });
    }
  }

  @override
  void setLocalAccessCode(String code) {
    setState(() {
      accessCode = code;
      body = Home(
        onSubmit: onCodeSubmit,
        onGenerate: onGenerateCode,
        accessCode: accessCode,
        formKey: formKey,
        generatedAccessCode: accessCode,
        onAccessCodeSaved: setLocalAccessCode,
      );
    });
  }

  @override
  void setAppState(AppState newState) {
    setState(() {
      state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Guripat"),
        ),
        body: presenter.body(context));
  }

  @override
  Future<bool> isCodeValid(BuildContext context, String code) async {
    var listProvider = Provider.of<ListProvider>(context, listen: false);
    if (await listProvider.checkConnection()) {
      var isValid = await listProvider.isCodeValid(code);
      print(isValid);
      return isValid;
    } else {
      return false;
    }
  }
}
