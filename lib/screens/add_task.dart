import 'package:flutter/material.dart';
import 'package:task_manager/globals.dart';
import 'package:task_manager/repository/database_helper.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/widgets/material_date_picker.dart';

import '../models/task_model.dart';




class AddTaskScreen extends StatefulWidget {

  bool fromEdit;
  int? id;
  String? title;
  String? description;
  String? date;
  bool? isImportant;
  bool? isDone;
    AddTaskScreen({
      required this.fromEdit,
      this.id,
      this.title,
      this.description,
      this.date,
      this.isImportant,
      this.isDone,
      super.key
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  List<Task> _tasks = [];
  bool important = false;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final DBHelper _databaseHelper = DBHelper();


  Future<void> _addTask() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    if (title.isNotEmpty && description.isNotEmpty) {
      Task newTask = Task(title: title, description:description , date: taskDate, isDone: false, isImportant:important);
      await _databaseHelper.insertTask(newTask);
      titleController.clear();
      descriptionController.clear();
      _loadTodos();

    }
  }

  void _loadTodos() async {
    final tasks = await _databaseHelper.getTodos();
    setState(() {
      _tasks = tasks;
    });
  }

  void showTaskData(){
    if(widget.fromEdit == true){
      titleController.text = widget.title!;
      descriptionController.text = widget.description!;
      taskDate = widget.date!;
      important = widget.isImportant!;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showTaskData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white,),
        ),
        elevation: 2.0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Add Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("TITLE", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        isDense: true,
                        // label: const Text('TITLE'),
                        hintText: 'Add Task Title'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text("Description".toUpperCase(), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),),
                 TextFormField(
                   controller: descriptionController,
                   decoration:  InputDecoration(
                       isDense: true,
                       // label: Text('Description'.toUpperCase()),
                       hintText: 'Write Task Description'
                   ),
                 ),
               ],
             ),
              const SizedBox(
                height: 10,
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text('Important Task'),
                activeColor: Colors.white,
                activeTrackColor: Colors.black,
                value: important,
                onChanged: (value) => setState(
                      () {
                    important = value;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomDatePicker(),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: (){
                  if(widget.fromEdit == true){
                    _databaseHelper.updateTask(widget.id!, titleController.text, descriptionController.text, taskDate, important);
                  }else{
                    _addTask();
                  }
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomeScreen()));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: const Text(
                      'ADD TASK',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    ), onWillPop: () async{
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomeScreen()));
      return false;
    }) ;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

}
