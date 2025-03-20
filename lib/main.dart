import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/elements/widget/tab_navigation.dart';
import 'package:mobile_labs/pages/home_page.dart';
import 'package:mobile_labs/pages/login_page.dart';
import 'package:mobile_labs/pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
   const storage = FlutterSecureStorage();

  final String? value = await storage.read(key: 'login');
  runApp(MyApp(isRegistered: (value == 'yes')));
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
