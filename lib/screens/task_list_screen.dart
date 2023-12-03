import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo List',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 114, 127, 208),
        leading: const Icon(
          Icons.task_rounded,
          color: Colors.white,
          size: 30,
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/todo.png',
            height: MediaQuery.of(context).size.height / 4,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: const Color.fromARGB(255, 71, 62, 62),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(task.description,
                          overflow: TextOverflow.ellipsis, maxLines: 2),
                      leading: Checkbox(
                        fillColor: MaterialStateProperty.all(Colors.green),
                        value: task.isCompleted,
                        onChanged: (newValue) {
                          taskProvider.updateTaskCompletionStatus(
                              index, newValue!);
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          taskProvider.deleteTask(index);
                        },
                      ),
                      onLongPress: () {
                        _showEditDialog(context, taskProvider, index,
                            task.title, task.description);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String newTaskTitle = '';
          String subtitle = '';
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Create your task',
                    hintStyle: GoogleFonts.lato(fontWeight: FontWeight.w500),
                  ),
                  onChanged: (value) {
                    newTaskTitle = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter task description',
                    hintStyle: GoogleFonts.lato(),
                  ),
                  onChanged: (value) {
                    subtitle = value;
                  },
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditDialog(BuildContext context, TaskProvider taskProvider,
      int index, String currentTitle, String description) {
    String updatedTitle = currentTitle;
    String updatedDescription = description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Edit Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: TextEditingController(text: currentTitle),
                  onChanged: (value) {
                    updatedTitle = value;
                  },
                ),
                TextField(
                  controller: TextEditingController(text: description),
                  onChanged: (value) {
                    updatedDescription = value;
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  taskProvider.updateTaskTitle(
                      index, updatedTitle, description);
                  Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink),
                ),
              )
            ]);
      },
    );
  }
}
