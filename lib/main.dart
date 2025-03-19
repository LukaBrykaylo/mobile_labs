import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_labs/elements/widget/tab_navigation.dart';
import 'package:mobile_labs/pages/home_page.dart';
import 'package:mobile_labs/pages/login_page.dart';
import 'package:mobile_labs/pages/signup_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LogInPage(),
        '/signup': (context) => const SignUpPage(),
        '/tabs': (context) => const TabNavigation(),
      },
    );
  }
}
