import 'package:flutter/material.dart';
import 'package:frontend/core/state/app_state.dart';
import 'package:frontend/features/list/widgets/item_tile.dart';
import 'package:frontend/models/item.dart';
import 'package:frontend/models/new_item.dart';
import 'package:frontend/providers/item_provider.dart';
import 'package:frontend/providers/list_provider.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late AppState state;
  List<Item> items = [];
  Map itemType = {"Perishable": true, "Non-Perishable": false};
  bool isPerishable = false;
  String itemTypeInput = "Perishable";

  NewItem newItem = NewItem(name: "", isPerishable: false, quantity: 0);

  var formKey = GlobalKey<FormState>();

  Widget buildList() {
    if (state == AppState.done) {
      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Your list is empty."),
            ],
          ),
        );
      }

      return Container(
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (contex, index) {
              return ItemListTile(
                item: items[index],
                functionOnEdit: showEditDialog,
                functionOnTileTap: markAsDone,
                functionOnDelete: deleteItem,
              );
            }),
      );
    } else if (state == AppState.loading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("An error has occured!"),
            SizedBox(height: 15),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    state = AppState.done;
                  });
                },
                child: Text("Okay")),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    state = AppState.loading;

    var provider = Provider.of<ItemProvider>(context, listen: false);
    provider.getItems().then((value) {
      // state = AppState.done;
      setState(() {
        items = value;
        state = AppState.done;
      });
    });
    super.initState();
  }

  void getItems() async {
    var provider = Provider.of<ItemProvider>(context, listen: false);
    var isConnected = await provider.checkInternet();
    if (isConnected) {
      provider.getItems().then((value) {
        setState(() {
          items = value;
        });
      });
    } else {
      setState(() {
        state = AppState.done;
      });
      noInternetDialog();
    }
  }

  void editQuantity(Item item) async {
    setState(() {
      state = AppState.loading;
    });
    var provider = Provider.of<ItemProvider>(context, listen: false);
    var isConnected = await provider.checkInternet();
    if (isConnected) {
      var isSuccess = await provider.editItemQuantity(item);
      print("Edit success!?");
      print(isSuccess);
      if (isSuccess) {
        provider.getItems().then((value) {
          setState(() {
            items = value;
            state = AppState.done;
          });
        });
      }
    } else {
      setState(() {
        state = AppState.done;
      });
      noInternetDialog();
    }
  }

  void markAsDone(Item item) async {
    setState(() {
      state = AppState.loading;
    });
    var provider = Provider.of<ItemProvider>(context, listen: false);
    var isConnected = await provider.checkInternet();
    if (isConnected) {
      var isSuccess = await provider.markItemAsComplete(item);
      print("Mark success!?");
      print(isSuccess);
      if (isSuccess) {
        provider.getItems().then((value) {
          setState(() {
            items = value;
            state = AppState.done;
          });
        });
      }
    } else {
      setState(() {
        state = AppState.done;
      });
      noInternetDialog();
    }
  }

  void deleteItem(Item item) async {
    setState(() {
      state = AppState.loading;
    });
    var provider = Provider.of<ItemProvider>(context, listen: false);
    var isConnected = await provider.checkInternet();
    if (isConnected) {
      var isSuccess = await provider.deleteItem(item);
      print("Delete success!?");
      print(isSuccess);
      if (isSuccess) {
        provider.getItems().then((value) {
          setState(() {
            items = value;
            state = AppState.done;
          });
        });
      }
    } else {
      setState(() {
        state = AppState.done;
      });
      noInternetDialog();
    }
  }

  void addItem() async {
    setState(() {
      state = AppState.loading;
    });
    var provider = Provider.of<ItemProvider>(context, listen: false);

    var isConnected = await provider.checkInternet();

    if (isConnected) {
      await provider.addItem(newItem);
      provider.getItems().then((value) {
        setState(() {
          items = value;
          state = AppState.done;
        });
      });
    } else {
      setState(() {
        state = AppState.done;
      });
      noInternetDialog();
    }
  }

  void exitList() async {
    setState(() {
      state = AppState.loading;
    });
    var provider = Provider.of<ListProvider>(context, listen: false);
    provider.deleteAccessCode();
  }

  String countCompleted() {
    if (items.isEmpty) {
      return "Guripat Checklist App";
    }
    var completed =
        items.where((element) => element.quantity == 0).toList().length;
    var total = items.length;
    return "$completed out of $total completed";
  }

  bool isCompleted() {
    var completed =
        items.where((element) => element.quantity == 0).toList().length;
    var total = items.length;

    return completed == total ? true : false;
  }

  Future<void> showCompletionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Check List Completed!"),
          content: SingleChildScrollView(
              child: Text(
                  "Great job! Looks like someone ain't gonna get a guripat today.")),
          actions: [
            TextButton(
                child: Text("Yey"),
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
    return Consumer<ItemProvider>(
      builder: (context, provider, child) {
        provider.datasource.client = GraphQLClient(
            link: HttpLink('http://localhost:5000/graphql'),
            cache: GraphQLCache());

        // if (isCompleted()) {
        //   showCompletionDialog();
        // }

        return Scaffold(
            floatingActionButton: FloatingActionButton(
              key: Key("addButton"),
              child: Icon(Icons.add),
              onPressed: showAddDialog,
            ),
            appBar: AppBar(
              centerTitle: true,
              leading: Icon(Icons.list_alt_outlined),
              title: Text(countCompleted()),
              actions: [
                IconButton(
                    onPressed: () {
                      exitList();
                    },
                    icon: Icon(Icons.logout_rounded)),
              ],
            ),
            body: buildList());
      },
    );
  }

  Future<void> noInternetDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No internet!"),
          content: SingleChildScrollView(
              child: Text(
                  "The app can't access the internet right now. Try again later.")),
          actions: [
            TextButton(
                child: Text("Aw snap!"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  Future<void> showEditDialog(Item item) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var localKey = GlobalKey<FormState>();
        var localNewItem = item;

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            key: Key("editDialog"),
            title: Text("Edit item quantity"),
            content: SingleChildScrollView(
              child: Form(
                key: localKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: Key("quantityEdit"),
                      initialValue: "${item.quantity}",
                      decoration: InputDecoration(
                        labelText: '  Quantity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if (int.tryParse(value!) == null) {
                          return "A valid quantity is required!";
                        }
                        if (int.tryParse(value)! > 1000000) {
                          return "Quantity is invalid!";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        localNewItem.quantity = int.parse(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  child: Text("Submit"),
                  onPressed: () {
                    if (!localKey.currentState!.validate()) {
                      return;
                    } else {
                      editQuantity(localNewItem);
                      Navigator.of(context).pop();
                    }
                  }),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
      },
    );
  }

  Future<void> showAddDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // bool isChecked = false;
  

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            key: Key("addDialog"),
            title: Text("Add Item"),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
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
                        newItem.name = value;
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

                        if (int.tryParse(value)! > 1000000) {
                          return "Quantity is invalid!";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        newItem.quantity = int.parse(value);
                      },
                    ),
                    CheckboxListTile(
                        value: isPerishable,
                        title: Text("Perishable"),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) {
                          setState(() {
                            if (isPerishable) {
                              // isChecked = false;
                              isPerishable = false;
                              newItem.isPerishable = false;
                              print(isPerishable);
                            } else {
                              // isChecked = true;
                              isPerishable = true;
                              newItem.isPerishable = true;
                              print(isPerishable);
                            }
                          });
                        }),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  child: Text("Submit"),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    } else {
                      addItem();
                      Navigator.of(context).pop();
                    }
                  }),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
      },
    );
  }
}
