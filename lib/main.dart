import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 🔹 Firebase
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/top_rated_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 🔹 Ensures all bindings are initialized
  await Firebase.initializeApp(); // 🔹 Firebase initialization
  runApp(TravelApp());
}

class TravelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RahiGo',
      debugShowCheckedModeBanner: false,
      theme: rahiTheme, // 🎨 Royal Indian Custom Theme
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/top-rated': (context) => TopRatedScreen(),
      },
    );
  }
}
