abstract class TabNavigationState {
  final int index;

  const TabNavigationState(this.index);
}

class ProfileTab extends TabNavigationState {
  const ProfileTab() : super(0);
}

class CameraTab extends TabNavigationState {
  const CameraTab() : super(1);
}

class AddCameraTab extends TabNavigationState {
  const AddCameraTab() : super(2);
}
