import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    _saveTasksToLocalStorage();
    notifyListeners();
  }

  void updateTaskCompletionStatus(int index, bool isCompleted) {
    _tasks[index].isCompleted = isCompleted;
    _saveTasksToLocalStorage();
    notifyListeners();
  }

  void updateTaskTitle(int index, String newTitle, String subtitle) {
    _tasks[index].title = newTitle;
    _tasks[index].description = subtitle;
    _saveTasksToLocalStorage();
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    _saveTasksToLocalStorage();
    notifyListeners();
  }

  // Load tasks from shared preferences
  Future<void> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final taskList = prefs.getStringList('task_list') ?? [];

      _tasks = taskList.map((taskJson) {
        final taskMap = json.decode(taskJson);
        return Task(taskMap['title'], taskMap['description'],
            isCompleted: taskMap['isCompleted']);
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> _saveTasksToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final taskList = _tasks
          .map(
            (task) => json.encode(
              {
                'title': task.title,
                'description': task.description,
                'isCompleted': task.isCompleted
              },
            ),
          )
          .toList();
      await prefs.setStringList('task_list', taskList);
      notifyListeners();
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }
}
