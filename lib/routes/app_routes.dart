import 'package:flutter/material.dart';

import '../features/auth/screens/email_entry_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/sign_in_screen.dart';
import '../features/feed/screens/feed_screen.dart';
import '../features/friends/screens/friends_screen.dart';
import '../features/history/screens/history_screen.dart';
import '../features/home_widget/screens/home_widget_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/settings/screens/settings_screen.dart';
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
  static const String friends = '/friends';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String homeWidget = '/home-widget';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
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
        return MaterialPageRoute(
          builder: (_) => const EmailEntryScreen(isSignUp: true),
        );
      case signIn:
        return MaterialPageRoute(
          builder: (_) => const EmailEntryScreen(isSignUp: false),
        );
      case home:
        return MaterialPageRoute(builder: (_) => const MainShell());
      case feed:
        return MaterialPageRoute(builder: (_) => const FeedScreen());
      case memories:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case friends:
        return MaterialPageRoute(builder: (_) => const FriendsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case homeWidget:
        return MaterialPageRoute(builder: (_) => const HomeWidgetScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
