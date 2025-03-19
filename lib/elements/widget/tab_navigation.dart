import 'package:flutter/material.dart';
import 'package:mobile_labs/pages/add_camera_page.dart';
import 'package:mobile_labs/pages/camera_page.dart';
import 'package:mobile_labs/pages/profile_page.dart';

class TabNavigation extends StatefulWidget {
  const TabNavigation({super.key});

  @override
  State<TabNavigation> createState() => _TabNavigationState();
}

class _TabNavigationState extends State<TabNavigation> {
  int _selectedIndex = 0;
  final List<String> _cameraNames = [];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ProfilePage(),
      CameraPage(cameraNames: _cameraNames),
      AddCameraPage(cameraNames: _cameraNames),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.linked_camera),
            label: 'Viewer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add),
            label: 'Add',
          ),
        ],
      ),
    );
  }
}
