import 'package:flutter/material.dart';
import 'todo.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  TodoProvider todo = TodoProvider("todo.db");
  String _subject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Subject"),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                      decoration: InputDecoration(labelText: "Subject"),
                      textInputAction: TextInputAction.go,
                      autofocus: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please fill subject";
                        }
                      },
                      onSaved: (value) {
                        this._subject = value;
                      },
                      onFieldSubmitted: (value) {
                        this._saveForm();
                      }),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text("Save"),
                          onPressed: () {
                            this._saveForm();
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            )));
  }

  void _saveForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      todo.insert(Todo(_subject));
      Navigator.of(context).pop();
    }
  }
}
