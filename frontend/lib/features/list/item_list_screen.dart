import 'package:flutter/material.dart';
import 'package:frontend/core/state/app_state.dart';
import 'package:frontend/features/list/widgets/item_tile.dart';
import 'package:frontend/models/item.dart';
import 'package:frontend/providers/item_provider.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  late AppState state;
  late List<Item> items; 
  Map itemType = {
    "Perishable": true,
    "Non-Perishable": false
  };

  String itemTypeInput = "Perishable";



  // dropped mvp archi because it was too tedious to accomplish
  Widget buildList(){
    if(state == AppState.done){
      return Container(
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (contex, index) {
              return ItemListTile(
                  item: items[index],
                  functionOnTap: (){print("Open!");});
            }),
      );
    } else if(state == AppState.loading){
      return Center(child: CircularProgressIndicator());



    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Oops, it looks like you've entered an invalid code!"),
            SizedBox(height: 15),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    state = AppState.done;
                  });
                },
                child: Text("Okay")
            ),
          ],
        ),
      );
    } 
  }

  @override
  void initState(){
    items = [
      Item(id: 2, name: "Beef 1 kilo", isPerishable: true, quantity: 10),
      Item(id: 3, name: "name", isPerishable: true, quantity: 25),
      Item(id: 1, name: "Rice 1 kilo", isPerishable: false, quantity: 5),
    ];

    state = AppState.done;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Consumer<ItemProvider>(
      // builder: (context, provider, child) {
        // provider.datasource.client = GraphQLClient(
        //   link: HttpLink('http://localhost:5000/graphql'),
        //   cache: GraphQLCache());
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: showMyDialog,
          ),
          appBar: AppBar(
            title: Text("List"),
          ),

          body: buildList()
        );
      // },
    // );
  }

  Widget alertDialog(){
    return AlertDialog(
      title: Text("Add Item"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              key: Key("name"),
              initialValue: "",
              decoration: InputDecoration(
                labelText: '  Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              validator: (value) {
                if (value == "") {
                  return "A name is required!";
                }
                return null;
              },
              onChanged: (value) {
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              key: Key("quantity"),
              initialValue: "",
              decoration: InputDecoration(
                labelText: '  Quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              validator: (value) {
                if (int.tryParse(value!) == null) {
                  return "A name is required!";
                }
                return null;
              },
              onChanged: (value) {
              },
            ),
            DropdownButton<String>(
              value: itemTypeInput,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(
                color: Colors.deepPurple
              ),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  itemTypeInput = newValue!;
                });
              },
              items: <String>['Perishable', 'Non-Perishable']
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                })
                .toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Submit"),
          onPressed: (){
            Navigator.of(context).pop();
          }
        ),
        TextButton(
          child: Text("Cancel"),
          onPressed: (){
            Navigator.of(context).pop();
          }
        ),
      ],
    );
}

Future<void> showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alertDialog();
    },
  );
}
}