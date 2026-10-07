import 'package:employee_directory/providers/auth_provider.dart';
import 'package:employee_directory/screens/auth/forgot_password_screen.dart';
import 'package:employee_directory/screens/auth/login_screen.dart';
import 'package:employee_directory/screens/auth/registration_screen.dart';
import 'package:employee_directory/screens/auth/reset_password_screen.dart';
import 'package:employee_directory/screens/auth/verify_otp_screen.dart';
import 'package:employee_directory/screens/home/home_screen.dart';
import 'package:employee_directory/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const verifyOtp = '/verify-otp';
  static const resetPassword = '/reset-password';
  static const home = '/home';

  // Pages a logged-out user may see.
  static const _publicRoutes = {
    login,
    register,
    forgotPassword,
    verifyOtp,
    resetPassword,
  };

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
        GoRoute(path: register, builder: (_, _) => const RegisterScreen()),
        GoRoute(path: forgotPassword,builder: (_, _) => const ForgotPasswordScreen(),),
        GoRoute(path: verifyOtp, builder: (_, _) => const VerifyOtpScreen()),
        GoRoute(path: resetPassword,builder: (_, _) => const ResetPasswordScreen(),),
        GoRoute(path: home, builder: (_, _) => const HomeScreen()),
      ],
    );
  }
}