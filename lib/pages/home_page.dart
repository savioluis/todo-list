import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/db/task_helper.dart';
import 'package:todo/db/task_model.dart';
import 'package:todo/pages/task_dialog_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskHelper _helper = TaskHelper();
  List<TaskModel> _taskList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _helper.getAll().then((list) {
      setState(() {
        _taskList = list;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de atividades"),
      ),
      body: _taskListWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _addNewTask,
      ),
    );
  }

  Widget _taskListWidget() {
    if (_taskList.isEmpty) {
      return Center(
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.brown)
            : Text("Você ainda não possui atividade 😮‍💨"),
      );
    } else {
      return ListView.builder(
        itemBuilder: _taskItemSlidableWidget,
        itemCount: _taskList.length,
      );
    }
  }

  Widget _taskItemWidget(BuildContext context, int index) {
    final task = _taskList[index];
    return CheckboxListTile(
        value: task.isDone,
        title: Text(task.title),
        subtitle: Text(task.description ?? "-"),
        onChanged: (bool? isChecked) {
          if (isChecked != null) {
            setState(() => task.isDone = isChecked);
            _helper.update(task);
          }
        });
  }

  Widget _taskItemSlidableWidget(BuildContext context, int index) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            onPressed: (context) {
              _addNewTask(actualTask: _taskList[index], index: index);
            },
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Editar',
          ),
          SlidableAction(
            onPressed: (context) {
              _deleteTask(deletedTask: _taskList[index], index: index);
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Deletar',
          ),
        ],
      ),
      child: _taskItemWidget(context, index),
    );
  }

  Future _addNewTask({TaskModel? actualTask, int? index}) async {
    final task = await showDialog<TaskModel>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return TaskDialogPage(task: actualTask);
      },
    );

    if (task != null) {
      setState(() {
        if (index == null) {
          _taskList.add(task);
          _helper.save(task);
        } else {
          _taskList[index] = task;
          _helper.update(task);
        }
      });
    }
  }

  void _deleteTask({required TaskModel deletedTask, required int index}) {
    setState(() {
      _taskList.removeAt(index);
    });

    _helper.delete(deletedTask.id);
  }
}
