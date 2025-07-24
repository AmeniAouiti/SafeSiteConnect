import 'package:flutter/material.dart';
import 'package:safesiteconnect/Views/HomeViews/EmployeeSpace/PageAlertes.dart';
import 'package:safesiteconnect/Views/HomeViews/EmployeeSpace/ProfilEmployePage.dart';
import 'package:safesiteconnect/Views/authView/VerifyOtpScreen.dart';
import '../Views/HomeViews/EmployeeSpace/HomeEmployee.dart';
import '../Views/HomeViews/EmployeeSpace/PointageScreen.dart';
import '../Views/HomeViews/EmployeeSpace/taskScreen.dart';
import '../Views/authView/ForgotPasswordScreen.dart';
import '../Views/authView/SignInScreen.dart';
import '../Views/authView/SignUpScreen.dart';

class AppRoutes {
  static const String signIn = '/signin';
  static const String home = '/home';
  static const String pointage = '/pointage';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot';
  static const String taskscreen = '/tasks';
  static const String alert = '/alert';
  static const String profile = '/profile';
  static const String verifyOtp = '/verifyOtp';





  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case pointage:
        return MaterialPageRoute(builder: (_) => const PointageScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case taskscreen:
        return MaterialPageRoute(builder: (_) => const TaskScreen());
      case alert:
        return MaterialPageRoute(builder: (_) => const PageAlertes());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilEmployePage());
      case verifyOtp:
        return MaterialPageRoute(builder: (_) => const VerifyCodeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page non trouvée')),
          ),
        );
    }
  }
}