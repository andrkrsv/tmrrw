import 'package:flutter/material.dart';
import 'package:tomorrow_app/pages/Planing.dart';
import '../settings.dart';
import 'scan_code_section.dart';
import 'settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Индекс выбранного раздела


  // Функция для обработки нажатия на элемент навигации
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Функция для построения содержимого выбранного раздела
  Widget _buildSectionContent() {
    switch (_selectedIndex) {
      case 0:
        return const TaskListPage(); // Раздел "Планирование"
      case 1:
        return const ScanCodeSection(); // Раздел "Сканировать код"
      case 2:
        return const ScanCodeSection(); // Раздел "Сканировать код"
      default:
        return const Center(
            child: Text('such empty:(')); // Обработка неизвестного индекса
    }
  }

  // Функция для построения кнопки навигации
  Widget _buildNavItem(String title, int index) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: ElevatedButton(
        onPressed: () => _onItemTapped(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedIndex == index
              ? Colors.pink
              : const Color.fromRGBO(
                  217, 217, 217, 1), // Выделение выбранного раздела
        ),
        child: Text(
          title,
          style: TextStyle(color: const Color.fromARGB(255, 72, 61, 61)),
        ),
      ),
    );
  }

  @override

  void initState() {
    super.initState();
    AppSettings.loadSettings().then((_) => setState(() {}));
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Hi there, noname!',
              style: TextStyle(
                  color: const Color.fromARGB(255, 72, 61, 61), fontSize: 32),
            ), // Приветствие пользователя (замените 'noname' на имя пользователя)
            const Spacer(), // Растягивает пространство между элементами
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Переход на экран настроек
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Область с кнопками навигации
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal, // Горизонтальная прокрутка
              children: [
                _buildNavItem('Планирование', 0),
                _buildNavItem('Сканировать код', 1),
                _buildNavItem('Расписание', 2),
              ],
            ),
          ),

          // Содержимое выбранного раздела
          Expanded(child: _buildSectionContent()),
        ],
      ),
    );
  }
}
