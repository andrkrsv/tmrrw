import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  String? selectedGroup;
  List<String> groups = [];

  @override
  void initState() {
    super.initState();
    _fetchGroups();
    _fetchCurrentGroup();
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

  Future<void> _fetchCurrentGroup() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        selectedGroup = userDoc.data()?['groupId'];
      });
    } catch (e) {
      print('Error fetching current group: $e');
    }
  }

  Future<void> _changeGroup(String newGroup) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'groupId': newGroup});
      setState(() {
        selectedGroup = newGroup;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Группа успешно изменена')),
      );
    } catch (e) {
      print('Error changing group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при изменении группы')),
      );
    }
  }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Выйти из аккаунта?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: signUserOut, // Вызываем signUserOut()
                      child: const Text('Выйти'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          // ... (другие настройки)

          // Dropdown для выбора группы
          DropdownButton<String>(
            value: selectedGroup,
            onChanged: (String? newValue) {
              if (newValue != null) {
                _changeGroup(newValue);
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
    );
  }
}
