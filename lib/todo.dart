import 'package:sqflite/sqflite.dart';

final String tableTodo = 'todo';
final String columnId = '_id';
final String columnSubject = 'subject';
final String columnDone = 'done';

class Todo {
  int id;
  String subject;
  bool done = false;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnSubject: subject,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo(this.subject);

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    subject = map[columnSubject];
    done = map[columnDone] == 1;
  }

  @override
  String toString(){
    return '{${this.id}, ${this.subject}, ${this.done}}';
  }
}

class TodoProvider {
  Database db;
  String path;

  TodoProvider(this.path);

  Future open() async {
    db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        create table $tableTodo ( 
          $columnId integer primary key autoincrement, 
          $columnSubject text not null,
          $columnDone integer not null
        )
        ''');
      }
    );
  }

  Future<Todo> insert(Todo todo) async {
    await this.open();
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<List<Todo>> getAllTodos() async {
    await this.open();
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnSubject]);
    List<Todo> list = maps.isNotEmpty ? maps.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<Todo> getTodo(int id) async {
    await this.open();
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnSubject],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    await this.open();
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    await this.open();
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteList(List<Todo> todos) async {
    bool success = false;
    for(Todo todo in todos){
      int temp = await this.delete(todo.id);
      success = success && (temp == 1);
    }
    return success ? 1 : 0;
  }

  Future close() async => db.close();
}
