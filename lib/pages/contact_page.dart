import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _formKey = GlobalKey<FormState>();

  String validateTextInput(String value)
  {

  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1,
            colors: [Colors.white, Color.fromARGB(255, 183, 187, 210)],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                // The validator receives the text that the user has entered.
                validator: validateTextInput,
              )
            ],
          )
        )
      ),
    );
  }
}