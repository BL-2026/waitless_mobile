import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/presentation/blocs/auth/login/login_bloc.dart';
import 'package:waitless_mobile/src/presentation/widgets/auth/google_sign_in_button.dart';
import 'package:waitless_mobile/src/presentation/widgets/auth/header.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/primary_button.dart';
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
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
              child: Column(
                children: [
                  AuthHeader(subtitle: '${l10n.staffAccess} · ${l10n.staffTagline}'),
                  const SizedBox(height: 36),
                  TextField(
                    decoration: fieldDecoration(
                      label: l10n.email,
                      suffixIcon: const Icon(
                        Icons.mail_outline,
                        color: AppColors.muted,
                      ),
                    ),
                    controller: emailController,
                    focusNode: emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    obscureText: !_isPasswordVisible,
                    decoration: fieldDecoration(
                      label: l10n.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
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
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, routeNameAuthForgotPassword);
                      },
                      child: Text(
                        l10n.forgotPassword,
                        style: const TextStyle(
                          color: AppColors.clay,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  PrimaryButton(
                    label: l10n.signIn,
                    loading: _isLoggingIn,
                    onPressed: () {
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        _signIn(
                          emailController.text.trim(),
                          passwordController.text,
                        );
                        emailFocusNode.unfocus();
                        passwordFocusNode.unfocus();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                            color: AppColors.clay,
                            message: l10n.enterCredentials,
                            iconData: Icons.close,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  AuthOrDivider(label: l10n.orLabel),
                  const SizedBox(height: 18),
                  GoogleSignInButton(
                    label: l10n.continueWithGoogle,
                    loading: _isLoggingIn,
                    onPressed: () {
                      context.read<LoginBloc>().add(
                        const SignInWithGoogleEvent(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      text: l10n.noAccount,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: l10n.signUp,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.espresso,
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
                            color: AppColors.sage,
                            message: l10n.loggedIn,
                            iconData: Icons.check,
                          ),
                        );
                        Navigator.pushReplacementNamed(
                          context,
                          routeNamePinPage,
                        );
                      } else if (state is LoginFailure) {
                        setState(() => _isLoggingIn = false);
                        showDialog(
                          context: context,
                          builder: (context) => AppAlert(
                            title: l10n.error,
                            content: state.errorMessage,
                            actionLabel: l10n.ok,
                          ),
                        );
                      } else if (state is LoggingIn) {
                        setState(() => _isLoggingIn = true);
                      } else if (state is LoginInitial) {
                        setState(() => _isLoggingIn = false);
                      }
                    },
                    builder: (context, state) => const SizedBox.shrink(),
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
