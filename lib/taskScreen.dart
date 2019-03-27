import 'package:flutter/material.dart';
import 'todo.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskScreenState();
  }
}

class TaskScreenState extends State<TaskScreen> {
  int _currentIndex = 0;
  List<Widget> _taskScreens = [];
  TodoProvider todo = TodoProvider("todolist.db");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: "Add",
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          )
        ],
      ),
      body: FutureBuilder<List<Todo>>(
        future: todo.getAllTodos(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> todoLists) {
          if (todoLists.hasData && todoLists.data.length > 0) {
            if (_currentIndex == 0){
              return ListView.builder(
                itemCount: todoLists.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Todo todolist = todoLists.data[index];
                  if(!todolist.done) {
                    return Column(
                      children: <Widget>[
                        CheckboxListTile(
                          title: Text(todolist.subject),
                          value: todolist.done,
                          onChanged: (bool value) {
                            todolist.done = value;
                            todo.update(todolist);
                          },
                        ),
                        Divider()
                      ],
                    );
                  }
                },
              );
            }
            else if(_currentIndex == 1){
              return ListView.builder(
                itemCount: todoLists.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Todo todolist = todoLists.data[index];
                  if(todolist.done) {
                    return Column(
                      children: <Widget>[
                        ListTile(title: Text(todolist.subject)),
                        Divider()
                      ],
                    );
                  }
                },
              );
            }
          } else {
            return Center(
              child: Text("No data found"),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabtapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Task")),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), title: Text("Completed"))
        ],
      ),
    );
  }

  Widget todolist() {
    return Container(
      child: FutureBuilder<List<Todo>>(
        future: todo.getAllTodos(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> todoLists) {
          if (todoLists.hasData) {
            return ListView.builder(
              itemCount: todoLists.data.length,
              itemBuilder: (BuildContext context, int index) {
                Todo todolist = todoLists.data[index];
                return ListTile(title: Text(todolist.subject));
              },
            );
          } else {
            return Center(
              child: Text("No data found"),
            );
          }
        },
      ),
    );
  }

  Widget completedList() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text("No completed data found."),
          ),
        )
      ],
    );
  }

  void onTabtapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
