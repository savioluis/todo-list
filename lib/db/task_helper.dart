import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/db/task_model.dart';

class TaskHelper {
  static final TaskHelper _instance = TaskHelper.internal();

  factory TaskHelper() => _instance;

  TaskHelper.internal();

  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final dataBasePath = await getDatabasesPath();
    final path = join(dataBasePath, "todo.db");

    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE task("
          "id INTEGER PRIMARY KEY,"
          "title TEXT, "
          "description TEXT, "
          "isDone INTEGER)");
    });
  }

  Future<int> delete(int id) async {
    Database? database = await db;
    return await database!.delete('task', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database? database = await db;
    return await database!.rawDelete("DELETE * from task");
  }

  Future<int> update(TaskModel task) async {
    Database? database = await db;
    return await database!
        .update('task', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<TaskModel> save(TaskModel task) async {
    Database? database = await db;
    task.id = await database!.insert('task', task.toMap());
    return task;
  }

  Future<int?> getCount() async {
    Database? database = await db;
    return Sqflite.firstIntValue(
        await database!.rawQuery("SELECT COUNT(*) FROM task"));
  }

  Future<List<TaskModel>> getAll() async {
    Database? database = await db;
    List listMap = await database!.rawQuery("SELECT * FROM task");
    List<TaskModel> list = listMap.map((e) => TaskModel.fromMap(e)).toList();
    return list;
  }

  Future<void> close() async {
    Database? database = await db;
    database!.close();
  }

  // Future<TaskModel> getById(int id) async {
  //   Database? database = await db;
  //   List<Map> maps = await database!.query(
  //     'task',
  //     columns: ['id', 'title', 'description', 'isDone'],
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  //
  //   if (maps.isNotEmpty) {
  //     return TaskModel.fromMap(maps.first);
  //   } else {
  //     return null;
  //   }
  // }
}
