import 'package:flutter/material.dart';
import 'package:safesiteconnect/navigation/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connexion App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005B96),
          primary: const Color(0xFF005B96),
          secondary: const Color(0xFF28A745),
          background: const Color(0xFFF0F0F0),
          surface: const Color(0xFFFFFFFF),
          onPrimary: const Color(0xFFFFFFFF),
          onSecondary: const Color(0xFFFFFFFF),
          onBackground: const Color(0xFF333333),
          onSurface: const Color(0xFF333333),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
          ),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF28A745),
            foregroundColor: const Color(0xFFFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF005B96),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF005B96)),
          ),
          labelStyle: const TextStyle(color: Color(0xFF333333)),
        ),
      ),

      // Utilisation des routes nommées
      initialRoute: AppRoutes.signIn,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
