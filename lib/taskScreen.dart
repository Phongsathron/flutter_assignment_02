import 'package:flutter/material.dart';
import 'model/todo.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskScreenState();
  }
}

class TaskScreenState extends State<TaskScreen> {
  int _currentIndex = 0;
  List<Todo> tasks = [];
  TodoProvider todo = TodoProvider("todo.db");

  @override
  Widget build(BuildContext context) {
    List<Widget> actionButton = [
      IconButton(
        icon: Icon(Icons.add),
        tooltip: 'Add',
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        tooltip: 'Delete',
        onPressed: () {
          _removeTasks(tasks.where((Todo task) => task.done).toList());
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        actions: <Widget>[
          actionButton[_currentIndex],
        ],
      ),
      body: FutureBuilder<List<Todo>>(
        future: todo.getAllTodos(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> todoLists) {
          if (todoLists.hasData) {
            tasks = todoLists.data;
            switch (_currentIndex) {
              case 0:
                return this._pageNotDone();
                break;
              case 1:
                return this._pageDone();
                break;
            }
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabtapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Task")),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), title: Text("Completed"))
        ],
      ),
    );
  }

  Widget _pageNotDone() {
    List<Todo> todoDone = tasks.where((Todo task) => !task.done).toList();
    return _buildTaskList(todoDone);
  }

  Widget _pageDone() {
    List<Todo> todoDone = tasks.where((Todo task) => task.done).toList();
    return _buildTaskList(todoDone);
  }

  Widget _buildTaskList(List<Todo> tasksList) {
    if (tasksList.length > 0) {
      return ListView.builder(
        itemCount: tasksList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              CheckboxListTile(
                title: Text(tasksList[index].title),
                value: tasksList[index].done,
                onChanged: (value) async {
                  setState(() {
                    tasks
                        .where((Todo task) => task.id == tasksList[index].id)
                        .first
                        .done = value;
                  });
                  await todo.update(tasksList[index]);
                },
              ),
              Divider(
                color: Colors.black,
              )
              // Divider()
            ],
          );
        },
      );
    } else {
      return Center(child: Text('No data found..'));
    }
  }

  void _onTabtapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _removeTasks(List<Todo> tasksList) {
    todo.deleteList(tasksList).then((s) {
      setState(() {
        tasksList.removeWhere((Todo x) => tasksList.contains(x));
      });
    });
  }
}
