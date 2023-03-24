import 'package:flutter/material.dart';
import 'package:todo/db/task_model.dart';

class TaskDialogPage extends StatefulWidget {
  final TaskModel? task;

  TaskDialogPage({Key? key, this.task}) : super(key: key);

  @override
  State<TaskDialogPage> createState() => _TaskDialogPageState();
}

class _TaskDialogPageState extends State<TaskDialogPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskModel _currentTask = TaskModel(id: 0, title: "");

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _currentTask = TaskModel.fromMap(widget.task!.toMap());
    }

    _titleController.text = _currentTask.title;
    _descriptionController.text = _currentTask.description ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Nova tarefa' : 'Editar tarefa'),
      content: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Titulo'),
            autofocus: true,
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Descrição'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Fechar"),
        ),
        TextButton(
          onPressed: () {
            _currentTask.title = _titleController.text;
            _currentTask.description = _descriptionController.text;

            Navigator.of(context).pop(_currentTask);
          },
          child: Text("Salvar"),
        ),
      ],
    );
  }
}
