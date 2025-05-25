import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/tab_navigation/tab_navigation_cubit.dart';
import 'package:mobile_labs/pages/add_camera_page.dart';
import 'package:mobile_labs/pages/camera_page.dart';
import 'package:mobile_labs/pages/profile_page.dart';

class TabNavigation extends StatelessWidget {
  const TabNavigation({super.key});

  Widget _buildPage(int index) {
    switch (index) {
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
    return BlocProvider(
      create: (_) => TabNavigationCubit(),
      child: BlocBuilder<TabNavigationCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: _buildPage(selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.greenAccent,
              unselectedItemColor: Colors.white54,
              currentIndex: selectedIndex,
              onTap: (index) =>
                  context.read<TabNavigationCubit>().changeTab(index),
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
        },
      ),
    );
  }
}
