import 'package:flutter/material.dart';

import '../features/auth/screens/email_entry_screen.dart';
import '../features/auth/screens/login_screen.dart';

import '../features/chat/screens/chat_screen.dart';

import '../features/friends/screens/friends_screen.dart';
import '../features/history/screens/history_feed_screen.dart';
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
  static const String historyFeed = '/history-feed';
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
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ChatScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );


      case memories:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HistoryScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );

      case historyFeed:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HistoryFeedScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );

      case friends:
        return PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.black.withValues(alpha: 0.6),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const FriendsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );

      case profile:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );

      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case homeWidget:
        return MaterialPageRoute(builder: (_) => const HomeWidgetScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
