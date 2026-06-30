import 'package:flutter/material.dart';
import 'ui/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Theme colors
    const Color cream = Color(0xFFFFF8EC);
    const Color brown = Color(0xFF5D4037);
    const Color orange = Color(0xFFE59A45);

    return MaterialApp(
      title: 'SPK Shine Bakery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: brown,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brown,
          primary: brown,
          secondary: orange,
          background: cream,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: brown,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: brown,
              displayColor: brown,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: brown,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}
