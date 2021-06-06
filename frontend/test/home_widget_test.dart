// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/datasources/list/list_remote_datasource.dart';
import 'package:frontend/features/home/screens/home_screen.dart';
import 'package:frontend/features/list/item_list_screen.dart';

import 'package:frontend/models/ItemList.dart';
import 'package:frontend/providers/list_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockItemListRemoteDatasource extends Mock
    implements ItemListRemoteDatasource {
  @override
  Future<bool> checkConnection() async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> codeIsValid(String code) async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteList(String code) async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ItemList> generateListCode() async {
    try {
      return ItemList(id: 1, code: "abd443a5-6761-451f-af2f-5eaf1d8a21af");
    } catch (e) {
      return ItemList(id: 0, code: "");
    }
  }
}

class MockMyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Guripat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<ListProvider>(
          builder: (context, currentList, child) {
            return currentList.list.code == "" ? HomeScreen() : ListScreen();
          },
        ));
  }
}

void main() {
  testWidgets('Pseudo "Login screen" test', (WidgetTester tester) async {
    var datasource = MockItemListRemoteDatasource();
    SharedPreferences.setMockInitialValues({});
    var localStorageInstance = SharedPreferences.getInstance();
    

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ListProvider>(
            create: (_) => ListProvider(
              datasource: datasource, 
              localStorageInstance: localStorageInstance
            ),
          ),
        ],
        builder: (context, child) {
          return MockMyApp();
        },
      ),
    );

    final accessCodeField = find.byKey(Key('accessCode'));
    final generatedAccessCodeField = find.byKey(Key('generatedAccessCode'));
    final proceedButton =
        find.widgetWithText(ElevatedButton, "Proceed to list");
    final generateButton =
        find.widgetWithText(ElevatedButton, "Generate list code");

    expect(accessCodeField, findsOneWidget);
    expect(generatedAccessCodeField, findsOneWidget);
    expect(proceedButton, findsOneWidget);
    expect(generateButton, findsOneWidget);

    await tester.tap(proceedButton);
    await tester.pumpAndSettle();

    expect(find.text("A list code is required to proceed!"), findsOneWidget);

  });
}
