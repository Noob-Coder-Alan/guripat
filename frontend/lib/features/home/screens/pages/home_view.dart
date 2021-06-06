import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  final Function onSubmit;

  Home({Key? key, required this.onSubmit});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
final _formKey = GlobalKey<FormState>();

  String accessCode = "";
  String generatedAccessCode = "";

  Widget buildListCodeField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '  List code',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (accessCode.isEmpty) {
          return "A list code is required to proceed!";
        }
        return null;
      },
      onSaved: (value) {
        if(value != null){
          accessCode = value;
        } else {
          accessCode = "";
        }
      },
    );
  }

  Widget buildGeneratedListCodeField() {
    return TextFormField(
      readOnly: true,
      initialValue: generatedAccessCode,
      decoration: InputDecoration(
        labelText: '  Generated List Code',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildListCodeField(),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    child: Text(
                      'Submit',
                      // style: TextStyle(),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState!.save();
                      widget.onSubmit(context, );
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  buildGeneratedListCodeField(),
                  ElevatedButton(
                    child: Text("Generate list code"),
                    onPressed: () {
                      //set generatedAccessCode
                    }, 
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

