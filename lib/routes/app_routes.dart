import 'package:flutter/material.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/sign_in_screen.dart';
import '../features/feed/screens/feed_screen.dart';
import '../features/history/screens/history_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import '../main_shell.dart';

class AppRoutes {
  static const String splash = '/';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String register = '/register';
  static const String signIn = '/sign-in';
  static const String home = '/home';
  static const String feed = '/feed';
  static const String memories = '/memories';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case landing:
      case login:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 300),
        );
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const MainShell());
      case feed:
        return MaterialPageRoute(builder: (_) => const FeedScreen());
      case memories:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
