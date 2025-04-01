import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_labs/elements/widget/tab_navigation.dart';
import 'package:mobile_labs/pages/home_page.dart';
import 'package:mobile_labs/pages/login_page.dart';
import 'package:mobile_labs/pages/signup_page.dart';
import 'package:mobile_labs/service/auth_service.dart';
import 'package:mobile_labs/service/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final storageService = SecureStorageService();
  final authService = AuthService(storageService);

  final bool isRegistered = await authService.isLoggedIn();

  runApp(MyApp(isRegistered: isRegistered));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.isRegistered, super.key});

  final bool isRegistered;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isRegistered ? '/tabs' : '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LogInPage(),
        '/signup': (context) => const SignUpPage(),
        '/tabs': (context) => const TabNavigation(),
      },
    );
  }
}
