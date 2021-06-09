import 'package:flutter/material.dart';
import 'package:frontend/models/item.dart';

class ItemListTile extends StatelessWidget {
  final Item item;
  final Function functionOnTap;

  const ItemListTile({
    Key? key, 
    required this.item, 
    required this.functionOnTap
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
          child: ListTile(
              contentPadding: EdgeInsets.only(left: 15, bottom: 5, top: 5, right: 5),
              // leading: Icon(Icons.done),
              trailing: Wrap(
                spacing: 15, // space between two icons
                children: <Widget>[
                  IconButton(onPressed: (){print("Delete: ${item.name}");}, icon:  Icon(Icons.library_add_check_sharp)),
                  IconButton(onPressed: (){print("Delete: ${item.name}");}, icon:  Icon(Icons.edit)),
                  IconButton(onPressed: (){print("Delete: ${item.name}");}, icon:  Icon(Icons.delete))
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
                functionOnTap();
              }),
          elevation: 5,
      ),
    );
  }
}