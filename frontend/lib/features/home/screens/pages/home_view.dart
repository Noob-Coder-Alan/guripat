import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final Function onGenerate;
  final Function onSubmit;
  final Function onAccessCodeSaved;
  final GlobalKey<FormState> formKey;
  final String accessCode;
  final String generatedAccessCode;

  Home(
      {Key? key,
      required this.onGenerate,
      required this.onSubmit,
      required this.onAccessCodeSaved,
      required this.formKey,
      required this.accessCode,
      required this.generatedAccessCode})
      : super(key: key);

  Widget buildListCodeField(BuildContext context) {
    print(generatedAccessCode);
    return TextFormField(
      key: Key("accessCode"),
      initialValue: accessCode,
      decoration: InputDecoration(
        labelText: '  List code',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == "") {
          return "A list code is required to proceed!";
        }
        return null;
      },
      onChanged: (value) {
        onAccessCodeSaved(value);
      },
    );
  }

  Widget buildGeneratedListCodeField() {
    return TextFormField(
      key: Key('generatedAccessCode'),
      readOnly: true,
      initialValue: generatedAccessCode,
      decoration: InputDecoration(
        labelText: '  Generated list code',
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
        margin: EdgeInsets.fromLTRB(25, 100, 25, 25),
        child: Form(
            key: formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Enter your list code here."),
                  SizedBox(
                    height: 15,
                  ),
                  buildListCodeField(context),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    key: Key("proceedToList"),
                    child: Text(
                      'Proceed to list',
                      // style: TextStyle(),
                    ),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      formKey.currentState!.save();
                      await onSubmit(context, accessCode);
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text("Don't have a code? Generate one below."),
                  SizedBox(
                    height: 7.5,
                  ),
                  Text("Always remember to keep your codes secure."),
                  SizedBox(
                    height: 15,
                  ),
                  buildGeneratedListCodeField(),
                  SizedBox(
                    height: 25,
                  ),

                  ElevatedButton(
                    key: Key("generate"),
                    child: Text("Generate list code"),
                    onPressed: () async {
                      onGenerate(context);
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
