import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/forgot_password/forgot_password_cubit.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/snackbars/custom_snack_bar.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/spinners/custom_loading_indicator.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/widget_styles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  late ForgotPasswordCubit forgotPasswordCubit;

  @override
  void initState() {
    super.initState();
    forgotPasswordCubit = context.read<ForgotPasswordCubit>();
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: const Text(
          "Mot de passe oublié",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.ink),
                    ),
                    clipBehavior: Clip.antiAlias,
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: Image.asset(
                      'assets/images/auth_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'S\'il vous plaît, entrez votre email pour réinitialiser votre mot de passe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          final email = emailController.text.trim();
                          _forgotPassword(email);
                          emailFocusNode.unfocus();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                              color: Colors.red,
                              message: 'Veuillez entrer un email',
                              iconData: Icons.close,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Soumettre',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state is ForgotPasswordEmailSent) {
                        emailController.clear();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                            color: Colors.green,
                            message: 'Veuillez vérifier votre email',
                            iconData: Icons.check,
                          ),
                        );
                      } else if (state is ForgotPasswordFailure) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
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
                      } else if (state is SendingEmail) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomLoadingIndicator(text: "loading....."),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    builder: (BuildContext context, ForgotPasswordState state) {
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

  void _forgotPassword(String email) {
    forgotPasswordCubit.forgotPassword(email);
  }
}
