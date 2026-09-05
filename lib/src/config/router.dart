import 'dart:developer';

import 'package:waitless_mobile/src/presentation/pages/auth/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/presentation/blocs/auth/login/login_bloc.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/forgot_password/forgot_password_cubit.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/logout/logout_cubit.dart';
import 'package:waitless_mobile/src/presentation/pages/auth/forgot_password_page.dart';
import 'package:waitless_mobile/src/presentation/pages/auth/login_page.dart';
import 'package:waitless_mobile/src/presentation/pages/pin_entry_page.dart';
import 'package:waitless_mobile/src/services/injection_container.dart';
import 'package:waitless_mobile/src/utils/constants/strings.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    log("route ${settings.name}");
    if (_shouldRedirectToLogin(settings)) {
      return _redirectToLogin();
    } else {
      return _handleValidRoute(settings);
    }
  }

  static bool _shouldRedirectToLogin(RouteSettings settings) {
    if (settings.name != routeNameAuthLogin &&
        settings.name != routeNameAuthForgotPassword &&
        settings.name != routeNameAuthSignUp &&
        FirebaseAuth.instance.currentUser == null) {
      return true;
    }
    return false;
  }

  static Route<dynamic> _redirectToLogin() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => sl<LoginBloc>(),
        child: LoginPage(),
      ),
    );
  }

  static Route<dynamic> _handleValidRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeNameAuthLogin:
        return _loginPageRoute();
      case routeNameAuthSignUp:
        return _signUpPageRoute();
      case routeNameAuthForgotPassword:
        return _forgotPasswordPageRoute();
      case routeNamePinPage:
        return _pinEntryPageRoute();
      default:
        _handleUnknownRoute();
        return _emptyPageRoute();
    }
  }

  static Route<dynamic> _loginPageRoute() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => sl<LoginBloc>(),
        child: LoginPage(),
      ),
    );
  }

  static Route<dynamic> _signUpPageRoute() {
    return MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<LoginBloc>(),
          )
        ],
        child: SignUpPage(),
      ),
    );
  }

  static Route<dynamic> _forgotPasswordPageRoute() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => sl<ForgotPasswordCubit>(),
        child: ForgotPasswordPage(),
      ),
    );
  }

  static Route<dynamic> _pinEntryPageRoute() {
    return MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<LogoutCubit>(),
          )
        ],
        child: PinEntryPage(),
      ),
    );
  }

  static void _handleUnknownRoute() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemNavigator.pop();
    });
  }

  static Route<dynamic> _emptyPageRoute() {
    return MaterialPageRoute(
      builder: (_) => Container(),
    );
  }
}
