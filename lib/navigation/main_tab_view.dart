import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/providers/theme_provider.dart';
import '../features/lecture/lecture_screen.dart';
import '../features/ecouter/ecouter_screen.dart';
import '../features/revision/revision_screen.dart';
import '../features/test/test_screen.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const LectureScreen(),
    const EcouterScreen(),
    const RevisionScreen(),
    const TestScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.bgDeepFor(isDarkMode),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.bgSurfaceFor(isDarkMode),
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.goldFor(isDarkMode),
        unselectedItemColor: AppColors.textSecondaryFor(isDarkMode),
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Lecture"),
          BottomNavigationBarItem(icon: Icon(Icons.headphones), label: "Écouter"),
          BottomNavigationBarItem(icon: Icon(Icons.refresh), label: "Réviser"),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: "Test"),
        ],
      ),
    );
  }
}