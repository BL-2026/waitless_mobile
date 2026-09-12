import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/presentation/blocs/auth/login/login_bloc.dart';
import 'package:waitless_mobile/src/presentation/widgets/auth/header.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/primary_button.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/snackbars/custom_snack_bar.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/constants/strings.dart';
import 'package:waitless_mobile/src/utils/helpers/helper_functions.dart';
import 'package:waitless_mobile/src/utils/widget_styles.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  PhoneNumber number = PhoneNumber(isoCode: 'MA', dialCode: '+212');

  /// Full international number as typed, e.g. `+212612345678`. The backend stores
  /// the dial code and the national part in separate columns, so [_splitPhone]
  /// pulls them apart before sending.
  String? phoneNumber;
  String? dialCode;
  bool isPhoneValid = false;
  bool isPasswordVisible = false;
  bool isSigningUp = false;

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoggingIn) {
            setState(() => isSigningUp = true);
          } else if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                color: AppColors.sage,
                message: l10n.accountCreated,
                iconData: Icons.check,
              ),
            );
            Navigator.pushReplacementNamed(context, routeNamePinPage);
          } else if (state is LoginFailure) {
            setState(() => isSigningUp = false);
            showDialog<void>(
              context: context,
              builder: (context) => AppAlert(
                title: l10n.error,
                content: state.errorMessage,
                actionLabel: l10n.ok,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                child: Column(
                  children: [
                    AuthHeader(subtitle: l10n.staffAccess),
                    const SizedBox(height: 32),
                    TextField(
                      controller: fullNameController,
                      focusNode: fullNameFocusNode,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      decoration: fieldDecoration(
                        label: l10n.fullName,
                        suffixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InternationalPhoneNumberInput(
                      onInputChanged: (value) {
                        setState(() {
                          phoneNumber = value.phoneNumber;
                          dialCode = value.dialCode;
                        });
                      },
                      onInputValidated: (isValid) {
                        setState(() => isPhoneValid = isValid);
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,
                      textFieldController: phoneNumberController,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: AppColors.espresso),
                      initialValue: number,
                      inputDecoration: fieldDecoration(label: ''),
                      inputBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.line),
                      ),
                      focusNode: phoneNumberFocusNode,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      decoration: fieldDecoration(
                        label: l10n.email,
                        suffixIcon: const Icon(
                          Icons.mail_outline,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      obscureText: !isPasswordVisible,
                      decoration: fieldDecoration(
                        label: l10n.password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.muted,
                          ),
                          onPressed: () => setState(
                            () => isPasswordVisible = !isPasswordVisible,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: l10n.signUp,
                      loading: isSigningUp,
                      onPressed: isSigningUp ? null : _submit,
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        text: l10n.alreadyHaveAccount,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: l10n.signIn,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.espresso,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushReplacementNamed(
                                context,
                                routeNameAuthLogin,
                              ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// `+212612345678` → `('+212', '612345678')`, matching the backend's
  /// `phoneArea` / `phoneNumber` columns.
  (String, String) _splitPhone() {
    final area = dialCode ?? number.dialCode ?? '';
    final full = phoneNumber ?? '';
    return (area, full.startsWith(area) ? full.substring(area.length) : full);
  }

  void _submit() {
    final l10n = context.l10n;
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (fullName.isEmpty ||
        phoneNumber == null ||
        !isPhoneValid ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          color: AppColors.clay,
          message: l10n.fillValidFields,
          iconData: Icons.close,
        ),
      );
      return;
    }

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          color: AppColors.clay,
          message: l10n.invalidEmail,
          iconData: Icons.close,
        ),
      );
      return;
    }

    final (phoneArea, nationalNumber) = _splitPhone();
    context.read<LoginBloc>().add(
      SignUpEvent(
        fullName: fullName,
        phoneArea: phoneArea,
        phoneNumber: nationalNumber,
        email: email,
        password: password,
      ),
    );
    fullNameFocusNode.unfocus();
    phoneNumberFocusNode.unfocus();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
  }
}
