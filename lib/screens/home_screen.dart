import 'package:flutter/material.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/repository/database_helper.dart';

import 'add_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDone = false;
  final DBHelper _databaseHelper = DBHelper();
  List<Task> _tasks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(_tasks.length);
    _loadTodos();
  }

  void _loadTodos() async {
    final tasks = await _databaseHelper.getTodos();
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        backgroundColor: Colors.black,
        title: Text(
          'Task list'.toUpperCase(),
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                    fromEdit: false,
                  )));
        },
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('You don\'t have any tasks yet'))
          : ListView.builder(
              padding: const EdgeInsets.only(top: 7.5),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Dismissible(
                    key: Key(_tasks[index].toString()),
                    background: Container(
                      color: Colors.black,
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      _databaseHelper.deleteTask(_tasks[index].id!);
                      _loadTodos();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('The task has been deleted'),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Card(
                            color: _tasks[index].isImportant == true
                                ? Colors.red.withOpacity(0.25)
                                : Colors.white,
                            margin: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: _tasks[index] == 0 ? 15 : 7.5,
                                bottom: 7.5),
                            elevation: 1.0,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _tasks[index].title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        _tasks[index].description,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        _tasks[index].date.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                  Checkbox(
                                    activeColor: Colors.black,
                                    checkColor: Colors.white,
                                    value: _tasks[index].isDone,
                                    onChanged: (value) {
                                      // Update the database and reload the list
                                      // when the checkbox is clicked

                                      setState(() {
                                        _tasks[index].isDone = value!;
                                        _databaseHelper.updateTaskDoneStatus(
                                            _tasks[index].id!, value);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                            ),
                        Positioned(
                            top: 7.5,
                            right: 15,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddTaskScreen(
                                          fromEdit: true,
                                          id: _tasks[index].id!,
                                          title: _tasks[index].title,
                                          description:
                                              _tasks[index].description,
                                          date: _tasks[index].date,
                                          isImportant:
                                              _tasks[index].isImportant,
                                          isDone: _tasks[index].isDone,
                                        )));
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                color: _tasks[index].isImportant == true
                                    ? Colors.white
                                    : Colors.black,
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: _tasks[index].isImportant == true
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ))
                      ],
                    ));
              },
            ),
    );
  }
}
