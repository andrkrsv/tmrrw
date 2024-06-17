import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> taskData;
  final bool isRootUser;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    Key? key,
    required this.taskData,
    required this.isRootUser,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskData['title'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(taskData['description']),
            const SizedBox(height: 16),
            Text(
              'Expires: ${taskData['dueDate']}',
            ),
            if (isRootUser) // Conditionally show the buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: onEdit,
                    child: const Text('Редактировать'),
                  ),
                  ElevatedButton(
                    onPressed: onDelete,
                    child: const Text('Удалить'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

