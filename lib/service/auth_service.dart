import 'package:flutter/material.dart';
import 'package:mobile_labs/service/storage_service.dart';

abstract class IAuthService extends ChangeNotifier {
  Future<void> signUp(BuildContext context, String name,
      String email, String password,);
  Future<void> logIn(BuildContext context, String username, String password);
  Future<void> logOut(BuildContext context);
  Future<bool> isLoggedIn();
  Future<Map<String, String?>> getUserInfo();
  Future<void> changePassword(BuildContext context,
      String oldPassword, String newPassword,);
  Future<void> deleteAccount(BuildContext context);
}

class AuthService extends ChangeNotifier implements IAuthService {
  final StorageService _storage;

  AuthService(this._storage);

  @override
  Future<void> signUp(BuildContext context, String name, String email,
      String password,) async {
    await _storage.write('login', 'yes');
    await _storage.write('name', name);
    await _storage.write('email', email);
    await _storage.write('password', password);
    notifyListeners();

    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/tabs');
  }

  @override
  Future<void> logIn(BuildContext context, String username,
      String password,) async {
    final String? storedName = await _storage.read('name');
    final String? storedPassword = await _storage.read('password');

    if (storedName == username && storedPassword == password) {
      await _storage.write('login', 'yes');
      notifyListeners();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/tabs');
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password'),
            backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Future<void> logOut(BuildContext context) async {
    await _storage.write('login', 'no');
    notifyListeners();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Future<bool> isLoggedIn() async {
    final String? loginStatus = await _storage.read('login');
    return loginStatus == 'yes';
  }

  @override
  Future<Map<String, String?>> getUserInfo() async {
    final String? name = await _storage.read('name');
    final String? email = await _storage.read('email');
    return {'name': name, 'email': email};
  }

  @override
  Future<void> changePassword(BuildContext context, String oldPassword,
      String newPassword,) async {
    final String? storedPassword = await _storage.read('password');
    if (storedPassword == oldPassword) {
      await _storage.write('password', newPassword);
      notifyListeners();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully'),
            backgroundColor: Colors.green,),
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect old password'),
            backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Future<void> deleteAccount(BuildContext context) async {
    await _storage.delete('login');
    await _storage.delete('name');
    await _storage.delete('email');
    await _storage.delete('password');
    notifyListeners();

    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deleted'),
          backgroundColor: Colors.red,),
    );
  }
}
