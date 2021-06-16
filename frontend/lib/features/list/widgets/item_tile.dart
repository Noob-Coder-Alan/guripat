import 'package:flutter/material.dart';
import 'package:frontend/models/item.dart';

class ItemListTile extends StatelessWidget {
  final Item item;
  final Function functionOnEdit;
  final Function functionOnTileTap;
  final Function functionOnDelete;

  const ItemListTile({
    Key? key,
    required this.item,
    required this.functionOnEdit,
    required this.functionOnTileTap,
    required this.functionOnDelete,
  }) : super(key: key);

  Future<void> deleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: (context),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Caution!"),
          content: SingleChildScrollView(
              child: Text("Are you sure you want to delete this item?")),
          actions: [
            TextButton(
              key: Key("deleteConfirm"),
                child: Text("Delete"),
                onPressed: () {
                  functionOnDelete(item);
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key("itemListTile"),
      height: 100,
      child: Card(
        child: ListTile(
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 5, top: 5, right: 5),
            leading: item.quantity > 0
                ? Icon(Icons.assignment_late_outlined)
                : Icon(Icons.assignment_turned_in_rounded),
            trailing: Wrap(
              spacing: 15, // space between two icons
              children: <Widget>[
                IconButton(
                  key: Key("editButton"),
                    onPressed: () {
                      functionOnEdit(item);
                    },
                    icon: Icon(Icons.edit)),
                IconButton(
                  key: Key("deleteButton"),
                    onPressed: () {
                      // functionOnDelete(item);
                      deleteDialog(context);
                    },
                    icon: Icon(Icons.delete))
              ],
            ),
            isThreeLine: true,
            title: Text(
              "Item: ${item.name}",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              'Quantity: ${item.quantity} \nPerishable: ${item.isPerishable ? "Yes" : "No"}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            onTap: () async {
              functionOnTileTap(item);
            }),
        elevation: 5,
      ),
    );
  }
}
