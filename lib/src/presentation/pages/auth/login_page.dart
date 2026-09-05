import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/presentation/blocs/auth/login/login_bloc.dart';
import 'package:waitless_mobile/src/presentation/widgets/auth/header.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/snackbars/custom_snack_bar.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/constants/strings.dart';
import 'package:waitless_mobile/src/utils/widget_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool _isLoggingIn = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildHeader(),
                  const SizedBox(height: 35),
                  TextField(
                    decoration: fieldDecoration(
                      label: 'Email',
                      suffixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.muted,
                      ),
                    ),
                    controller: emailController,
                    focusNode: emailFocusNode,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    obscureText: !_isPasswordVisible,
                    decoration: fieldDecoration(
                      label: 'Mot de Passe',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.muted,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              routeNameAuthForgotPassword,
                            );
                          },
                          child: const Text(
                            'Mot de passe oublié?',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.rust,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      icon: _isLoggingIn
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.login, color: Colors.white),
                      onPressed: () {
                        if (emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          final email = emailController.text.trim();
                          _signIn(email, passwordController.text);
                          emailFocusNode.unfocus();
                          passwordFocusNode.unfocus();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                              color: Colors.red,
                              message: 'Veuillez saisir vos identifiants.',
                              iconData: Icons.close,
                            ),
                          );
                        }
                      },
                      label: const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      text: "Vous n'avez pas de compte ? ",
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'S\'inscrire',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.rust,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(
                                context,
                                routeNameAuthSignUp,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                            color: Colors.green,
                            message: 'Vous êtes connecté',
                            iconData: Icons.check,
                          ),
                        );
                        Navigator.pushReplacementNamed(
                          context,
                          routeNamePinPage,
                        );
                      } else if (state is LoginFailure) {
                        setState(() {
                          _isLoggingIn = false;
                        });
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Erreur'),
                            content: Text(state.errorMessage),
                          ),
                        );
                      } else if (state is LoggingIn) {
                        setState(() {
                          _isLoggingIn = true;
                        });
                      }
                    },
                    builder: (context, state) {
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signIn(String email, String password) {
    context.read<LoginBloc>().add(
      SignInEvent(email: email, password: password),
    );
  }
}
