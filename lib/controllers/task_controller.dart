import 'package:flutter_noteapp/db/db_helper.dart';
import 'package:flutter_noteapp/models/task.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TaskController extends GetxController{
  
  @override
  void onReady(){
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.querry();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task)async {
    DBHelper.delete(task);
    getTasks();
  }

  
  void markTaskCompleted(int id) async {
   DBHelper.update(id); // Assuming DBHelper.update is an asynchronous function
  getTasks(); // Assuming getTasks() retrieves tasks from the database
  } 

}