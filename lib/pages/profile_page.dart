import 'package:flutter/material.dart';
import 'package:mobile_labs/elements/widget/settings_popup.dart';
import 'package:mobile_labs/service/auth_service.dart';
import 'package:mobile_labs/service/storage_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final IAuthService _authService = AuthService(SecureStorageService());
  String? _name, _email;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await _authService.getUserInfo();
    setState(() {
      _name = userInfo['name'];
      _email = userInfo['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('lib/elements/photos/background_small.jpg',
                fit: BoxFit.cover,),
          ),
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings,
                            color: Colors.white, size: 28,),
                        onPressed: () => showDialog<void>(
                            context: context,
                            barrierColor: Colors.transparent,
                            builder: (_) => const SettingsPopup(),),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout,
                            color: Colors.white, size: 28,),
                        onPressed: () => _authService.logOut(context),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInfoSection('Name:', _name ?? 'Unknown'),
                        const SizedBox(height: 16),
                        _buildInfoSection('Email:', _email ?? 'Unknown'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 18)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,),),
      ],
    );
  }
}
