import 'package:flutter/material.dart';
import 'package:freshflow_app/features/chat/presentation/chat_page.dart';
import 'package:freshflow_app/features/onboarding/presentation/splash_page.dart';
import 'package:freshflow_app/features/onboarding/presentation/login_page.dart';
import 'package:freshflow_app/features/onboarding/presentation/register_page.dart';
import 'package:freshflow_app/features/shell/presentation/root_shell.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String chat = '/chat';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const RootShell());
      case AppRoutes.chat:
        return MaterialPageRoute(builder: (_) => const ChatPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
