// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Guripat', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final listCodeField = find.byValueKey("accessCode");
    final proceedButton = find.byValueKey("proceedToList");
    final addButton = find.byValueKey("addButton");

    final nameField = find.byValueKey("name");
    final quantityField = find.byValueKey("quantity");
    final submitButton = find.byValueKey("submitItem");

    final listTile = find.byValueKey("itemListTile");
    final editButton = find.byValueKey("editButton");
    final quantityEditField = find.byValueKey("quantityEdit");
    final editSubmit = find.byValueKey("editSubmit");

    final deleteButton = find.byValueKey("deleteButton");
    final confirmDeleteButton = find.byValueKey("deleteConfirm");

    final logOutButton = find.byValueKey("logOut");




    // final buttonFinder = find.byValueKey('increment');


    late FlutterDriver driver;
    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('Login using list code', () async {
      await driver.tap(listCodeField);
      await driver.enterText("b2d40427-c43a-49df-9c5f-b9b1cc5700cf");

      await driver.tap(proceedButton);
      await driver.waitFor(find.text("Your list is empty."));
    });

    test('Adding item', () async {
      await driver.tap(addButton);
      await driver.tap(nameField);
      await driver.enterText("Eggs");
      await driver.tap(quantityField);
      await driver.enterText("10");
      await driver.tap(submitButton);
      await driver.waitFor(find.byValueKey("itemListTile"));
    });

    test('Marking item as done', () async {
      await driver.tap(listTile);
    });

    test('Edit Item', () async {
      await driver.tap(editButton);
      await driver.tap(quantityEditField);
      await driver.enterText("20");
      await driver.tap(editSubmit);
    });

    test('Delete item', () async {
      await driver.tap(deleteButton);
      await driver.tap(confirmDeleteButton);
      await driver.waitFor(find.text("Your list is empty."));
      
    });

    test('Exit from list', () async {
      await driver.tap(logOutButton);
      await driver.waitFor(find.text("Enter your list code here."));

    });
 
  });
}