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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return const ProfilePage();
      case 1:
        return const CameraPage();
      case 2:
        return const AddCameraPage();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
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
