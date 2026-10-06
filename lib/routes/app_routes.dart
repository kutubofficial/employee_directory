import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/splash/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  // Pages a logged-out user may see. Add forgot-password / OTP routes later.
  static const _publicRoutes = {login, register};

  static GoRouter create(AuthProvider auth) {
    return GoRouter(
      initialLocation: splash,
      refreshListenable: auth, // re-runs redirect whenever auth state changes
      redirect: (context, state) {
        final loc = state.matchedLocation;

        // Session check still running: keep the user on the splash.
        if (!auth.initialized) return loc == splash ? null : splash;

        final loggedIn = auth.isLoggedIn;
        if (loc == splash) return loggedIn ? home : login;
        if (!loggedIn && !_publicRoutes.contains(loc)) return login;
        if (loggedIn && _publicRoutes.contains(loc)) return home;
        return null;
      },
      routes: [
        GoRoute(path: splash, builder: (_, _) => const SplashScreen()),
        GoRoute(path: login, builder: (_, _) => const LoginScreen()),
        GoRoute(
          path: register,
          // TODO: replace with RegisterScreen
          builder: (_, _) => const Scaffold(body: Center(child: Text('Register'))),
        ),
        GoRoute(path: home, builder: (_, _) => const HomeScreen()),
      ],
    );
  }
}