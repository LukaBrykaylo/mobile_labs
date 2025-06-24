import 'package:mobile_labs/service/storage_service.dart';

abstract class IAuthService {
  Future<bool> signUp(String name, String email, String password);
  Future<bool> logIn(String username, String password);
  Future<void> logOut();
  Future<bool> isLoggedIn();
  Future<Map<String, String?>> getUserInfo();
  Future<bool> changePassword(String oldPassword, String newPassword);
  Future<void> deleteAccount();
}

class AuthService implements IAuthService {
  final StorageService _storage;

  AuthService(this._storage);

  @override
  Future<bool> signUp(String name, String email, String password) async {
    await _storage.write('login', 'yes');
    await _storage.write('name', name);
    await _storage.write('email', email);
    await _storage.write('password', password);
    return true;
  }

  @override
  Future<bool> logIn(String username, String password) async {
    final storedName = await _storage.read('name');
    final storedPassword = await _storage.read('password');

    if (storedName == username && storedPassword == password) {
      await _storage.write('login', 'yes');
      return true;
    }
    return false;
  }

  @override
  Future<void> logOut() async {
    await _storage.write('login', 'no');
  }

  @override
  Future<bool> isLoggedIn() async {
    final loginStatus = await _storage.read('login');
    return loginStatus == 'yes';
  }

  @override
  Future<Map<String, String?>> getUserInfo() async {
    final name = await _storage.read('name');
    final email = await _storage.read('email');
    return {'name': name, 'email': email};
  }

  @override
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final storedPassword = await _storage.read('password');
    if (storedPassword == oldPassword) {
      await _storage.write('password', newPassword);
      return true;
    }
    return false;
  }

  @override
  Future<void> deleteAccount() async {
    await _storage.delete('login');
    await _storage.delete('name');
    await _storage.delete('email');
    await _storage.delete('password');
  }
}
