import 'package:flutter/material.dart';
import 'todo.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  TodoProvider todo = TodoProvider("todolist.db");
  String _subject;

  @override
  Widget build(BuildContext context) {
    // todo.open("todolist.db");
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
                    validator: (value) {
                      if(value.isEmpty){
                        return "Please fill subject";
                      }
                    },
                    onSaved: (value) {
                      this._subject = value;
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text("Save"),
                          onPressed: () {
                            if(_formKey.currentState.validate()){
                              _formKey.currentState.save();
                              todo.insert(Todo(_subject));
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            )));
  }
}
