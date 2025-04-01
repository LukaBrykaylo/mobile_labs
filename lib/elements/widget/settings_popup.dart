import 'package:flutter/material.dart';
import 'package:mobile_labs/service/auth_service.dart';
import 'package:mobile_labs/service/storage_service.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({super.key});

  void _changePassword(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        final TextEditingController oldPasswordController =
            TextEditingController();
        final TextEditingController newPasswordController =
            TextEditingController();
        final IAuthService authService = AuthService(SecureStorageService());

        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                decoration: const InputDecoration(labelText: 'Old Password'),
                obscureText: true,
              ),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await authService.changePassword(
                  context,
                  oldPasswordController.text,
                  newPasswordController.text,
                );
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(BuildContext context) async {
    final IAuthService authService = AuthService(SecureStorageService());
    await authService.deleteAccount(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () => _changePassword(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Account'),
            onTap: () => _deleteAccount(context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
