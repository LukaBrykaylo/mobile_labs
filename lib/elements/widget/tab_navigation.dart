import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/tab_navigation/tab_navigation_cubit.dart';
import 'package:mobile_labs/cubit/tab_navigation/tab_navigation_state.dart';
import 'package:mobile_labs/pages/add_camera_page.dart';
import 'package:mobile_labs/pages/camera_page.dart';
import 'package:mobile_labs/pages/profile_page.dart';

class TabNavigation extends StatelessWidget {
  const TabNavigation({super.key});

  Widget _buildPage(TabNavigationState state) {
    if (state is ProfileTab) return const ProfilePage();
    if (state is CameraTab) return const CameraPage();
    if (state is AddCameraTab) return const AddCameraPage();
    return const Center(child: Text('Page not found'));
  }

  int _getIndexFromState(TabNavigationState state) => state.index;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TabNavigationCubit(),
      child: BlocBuilder<TabNavigationCubit, TabNavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: _buildPage(state),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.greenAccent,
              unselectedItemColor: Colors.white54,
              currentIndex: _getIndexFromState(state),
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
