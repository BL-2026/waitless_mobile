import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/forgot_password/forgot_password_cubit.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/primary_button.dart';
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
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: Text(l10n.forgotPasswordTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    l10n.forgotPasswordHint,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.muted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),
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
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: l10n.submit,
                    onPressed: () {
                      if (emailController.text.isNotEmpty) {
                        _forgotPassword(emailController.text.trim());
                        emailFocusNode.unfocus();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                            color: AppColors.clay,
                            message: l10n.enterEmail,
                            iconData: Icons.close,
                          ),
                        );
                      }
                    },
                  ),
                  BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state is ForgotPasswordEmailSent) {
                        emailController.clear();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                            color: AppColors.sage,
                            message: l10n.checkEmail,
                            iconData: Icons.check,
                          ),
                        );
                      } else if (state is ForgotPasswordFailure) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        showDialog(
                          context: context,
                          builder: (context) => AppAlert(
                            title: l10n.error,
                            content: state.errorMessage,
                            actionLabel: l10n.ok,
                          ),
                        );
                      } else if (state is SendingEmail) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: CustomLoadingIndicator(text: l10n.loading),
                          ),
                        );
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

  void _forgotPassword(String email) {
    forgotPasswordCubit.forgotPassword(email);
  }
}
