import 'package:flutter/material.dart';
import 'package:teacher_app/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:teacher_app/presentation/screens/add_student_screen.dart';
import 'package:teacher_app/presentation/screens/students_screen.dart';

class MainScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const MainScreen(),
      );
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      body: PageView(
        controller: navigationProvider.pageController,
        onPageChanged: (index) {
          navigationProvider.setIndex(index);
        },
        children: const [
          StudentsScreen(),
          AddStudentScreen(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: navigationProvider.currentIndex,
          onTap: (index) {
            navigationProvider.setIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Students',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Student',
            ),
          ],
        ),
      ),
    );
  }
}
