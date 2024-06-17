import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/task_card.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  TaskListPageState createState() => TaskListPageState();
}

class TaskListPageState extends State<TaskListPage> {
  List<QueryDocumentSnapshot> taskListDocs = [];
  String? groupId; // Declare groupId as a member variable
  String? selectedGroupId; // ID of the selected group
  bool isRootUser = false;
  List<String> groups = [];

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _fetchGroupId();
    await _fetchGroups();
    _checkRootStatus();
    _loadTasks(); // Загружаем задачи после получения groupId
  }

  Future<void> _fetchGroupId() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          groupId = userDoc.data()?['groupId'] as String?;
        });
      }
    } catch (e) {
      print('Error fetching group ID: $e');
    }
  }

  Future<void> _fetchGroups() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('groups').get();
      setState(() {
        groups = snapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error fetching groups: $e');
    }
  }

  Future<void> _checkRootStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          isRootUser = userDoc.data()?['root'] ?? false;
        });
      }
    } catch (e) {
      print('Error fetching root status: $e');
    }
  }

  Future<void> _loadTasks() async {
    if (selectedGroupId == null) {
      // Если selectedGroupId не установлен, используем groupId пользователя
      selectedGroupId = groupId;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(selectedGroupId) // Используем selectedGroupId
          .collection('deadlines')
          .get();

      setState(() {
        taskListDocs = snapshot.docs;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
      // Добавьте обработку ошибок, например, вывод сообщения об ошибке
    }
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        // Переменные состояния внутри StatefulBuilder
        String taskTitle = '';
        String taskDescription = '';
        DateTime taskExpires = DateTime.now();
        String taskGroup = groupId ?? '';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Добавить задачу'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Название'),
                    onChanged: (value) => setState(() {
                      taskTitle = value;
                    }),
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Описание'),
                    onChanged: (value) => setState(() {
                      taskDescription = value;
                    }),
                  ),
                  TextButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: taskExpires,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != taskExpires) {
                        setState(() {
                          taskExpires = pickedDate;
                        });
                      }
                    },
                    child: Text(
                        'Дата окончания: ${DateFormat('dd.MM.yy').format(taskExpires)}'),
                  ),
                  DropdownButton<String>(
                    value: taskGroup,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          taskGroup = newValue;
                        });
                      }
                    },
                    items: groups.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('groups')
                        .doc(taskGroup)
                        .collection('deadlines')
                        .add({
                      'title': taskTitle,
                      'description': taskDescription,
                      'dueDate': DateFormat('dd.MM.yy').format(taskExpires),
                    });
                    Navigator.pop(context);
                    _loadTasks();
                  },
                  child: const Text('Добавить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTaskDialog(
      BuildContext context, Map<String, dynamic> taskData, String taskId) {
    TextEditingController taskTitleController =
        TextEditingController(text: taskData['title']);
    TextEditingController taskDescriptionController =
        TextEditingController(text: taskData['description']);
    DateTime taskExpires = DateFormat('dd.MM.yy').parse(taskData['dueDate']);
    String taskGroup = taskData['group'] ?? groupId ?? '';
    String initialGroup = taskGroup; // Store the initial group

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Редактировать задачу'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskTitleController,
                    decoration: const InputDecoration(labelText: 'Название'),
                  ),
                  TextField(
                    controller: taskDescriptionController,
                    decoration: const InputDecoration(labelText: 'Описание'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: taskExpires.isAfter(DateTime.now())
                            ? taskExpires
                            : DateTime
                                .now(), // Set initialDate to now if task is overdue
                        firstDate:
                            DateTime.now(), // Set to today to avoid past dates
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != taskExpires) {
                        setState(() {
                          taskExpires = pickedDate;
                        });
                      }
                    },
                    child: Text(
                        'Дата окончания: ${DateFormat('dd.MM.yy').format(taskExpires)}'),
                  ),
                  DropdownButton<String>(
                    value: taskGroup,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          taskGroup = newValue;
                        });
                      }
                    },
                    items: groups.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: () async {
                    // Check if the group has changed
                    if (taskGroup != initialGroup) {
                      // Delete task from the initial group
                      await _deleteTask(taskId, initialGroup);

                      // Add task to the new group
                      await FirebaseFirestore.instance
                          .collection('groups')
                          .doc(taskGroup)
                          .collection('deadlines')
                          .add({
                        'title': taskTitleController.text,
                        'description': taskDescriptionController.text,
                        'dueDate': DateFormat('dd.MM.yy').format(taskExpires),
                        'group': taskGroup,
                      });
                    } else {
                      // Update the task in the same group
                      await FirebaseFirestore.instance
                          .collection('groups')
                          .doc(taskGroup)
                          .collection('deadlines')
                          .doc(taskId)
                          .update({
                        'title': taskTitleController.text,
                        'description': taskDescriptionController.text,
                        'dueDate': DateFormat('dd.MM.yy').format(taskExpires),
                        'group': taskGroup,
                      });
                    }

                    Navigator.pop(context);
                    _loadTasks();
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteTask(String taskId, String taskGroup) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(taskGroup)
          .collection('deadlines')
          .doc(taskId)
          .delete();
      _loadTasks(); // Refresh task list after deletion
    } catch (e) {
      print('Error deleting task: $e');
      // Show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isRootUser)
            DropdownButton<String>(
              value: selectedGroupId,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedGroupId = newValue;
                  });
                  _loadTasks(); // Добавлен вызов _loadTasks()
                }
              },
              items: groups.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
          if (isRootUser)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddTaskDialog(context),
            ),
        ],
      ),
      body: taskListDocs.isEmpty
          ? const Center(child: Text('Дедлайны отсутствуют'))
          : ListView.builder(
              itemCount: taskListDocs.length,
              itemBuilder: (context, index) {
                final taskData =
                    taskListDocs[index].data() as Map<String, dynamic>;
                final taskId = taskListDocs[index].id;
                return TaskCard(
                  taskData: taskData,
                  isRootUser: isRootUser,
                  onEdit: () => _showEditTaskDialog(context, taskData, taskId),
                  onDelete: () =>
                      _deleteTask(taskId, taskData['group'] ?? groupId ?? ''),
                );
              },
            ),
    );
  }
}
