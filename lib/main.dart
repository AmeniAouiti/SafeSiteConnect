import 'package:flutter/material.dart';
import 'Views/authView/SignInScreen.dart';

// Point d'entrée principal de l'application
void main() {
  // Lance l'application Flutter en exécutant le widget MyApp
  runApp(const MyApp());
}

// Widget principal de l'application, définissant la configuration globale
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp configure l'application avec un thème, une page d'accueil et des options globales
    return MaterialApp(
      title: 'Connexion App', // Titre de l'application
      debugShowCheckedModeBanner: false, // Désactive la bannière de débogage rouge
      theme: ThemeData(
        // Définit le thème global avec une palette de couleurs personnalisée
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005B96), // Bleu profond comme couleur de base
          primary: const Color(0xFF005B96), // Couleur principale pour les éléments interactifs
          secondary: const Color(0xFF28A745), // Couleur secondaire (vert sécurité)
          background: const Color(0xFFF0F0F0), // Fond gris clair
          surface: const Color(0xFFFFFFFF), // Surfaces blanches (cartes, fonds de formulaires)
          onPrimary: const Color(0xFFFFFFFF), // Texte/icones sur couleur principale
          onSecondary: const Color(0xFFFFFFFF), // Texte/icones sur couleur secondaire
          onBackground: const Color(0xFF333333), // Texte sur fond gris clair
          onSurface: const Color(0xFF333333), // Texte sur surfaces blanches
        ),
        // Définit les styles de texte pour différents types de texte
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333), // Titre principal en gris foncé
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF333333), // Texte standard en gris foncé
          ),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600, // Texte pour boutons ou labels
          ),
        ),
        // Style des boutons élevés (ex. bouton de connexion/inscription)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF28A745), // Fond vert sécurité
            foregroundColor: const Color(0xFFFFFFFF), // Texte/icones blancs
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Bordures arrondies
            ),
          ),
        ),
        // Style des boutons textuels (ex. "Mot de passe oublié ?")
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF005B96), // Texte en bleu profond
          ),
        ),
        // Style des champs de saisie (text fields)
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Bordures arrondies
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF005B96)), // Bordure bleue au focus
          ),
          labelStyle: const TextStyle(color: Color(0xFF333333)), // Labels en gris foncé
        ),
      ),
      // Définit la page d'accueil comme étant SignInScreen
      home: const SignInScreen(),
    );
  }
}