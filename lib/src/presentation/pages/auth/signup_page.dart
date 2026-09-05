import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:waitless_mobile/src/presentation/blocs/auth/login/login_bloc.dart';
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
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  PhoneNumber number = PhoneNumber(isoCode: 'MA', dialCode: '+212');
  String? phoneNumber;
  bool isPhoneValid = false;
  bool isPasswordVisible = false;
  bool isSigningUp = false;

  @override
  void dispose() {
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoggingIn) {
            setState(() => isSigningUp = true);
          } else if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                color: Colors.green,
                message: 'Félicitations, votre compte a été créé avec succès',
                iconData: Icons.check,
              ),
            );
            Navigator.pushReplacementNamed(context, routeNamePinPage);
          } else if (state is LoginFailure) {
            setState(() => isSigningUp = false);
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text('Erreur'),
                content: Text(state.errorMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: AppColors.ink),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 35),
                    InternationalPhoneNumberInput(
                      onInputChanged: (value) {
                        setState(() => phoneNumber = value.phoneNumber);
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
                      selectorTextStyle: const TextStyle(color: AppColors.ink),
                      initialValue: number,
                      inputBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.ink),
                      ),
                      focusNode: phoneNumberFocusNode,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      decoration: fieldDecoration(
                        label: 'Email',
                        suffixIcon: const Icon(
                          Icons.email_outlined,
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
                        label: 'Mot de passe',
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.muted,
                          ),
                          onPressed: () => setState(
                            () => isPasswordVisible = !isPasswordVisible,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.ink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: isSigningUp
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.person_add_outlined,
                                color: Colors.white,
                              ),
                        onPressed: isSigningUp ? null : _submit,
                        label: const Text(
                          "S'inscrire",
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
                        text: 'Vous avez déjà un compte ? ',
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Se connecter',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.rust,
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

  Widget _buildHeader() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.ink, AppColors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: const Text(
            'Waitless',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.ink),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/auth_logo.png',
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  void _submit() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (phoneNumber == null ||
        !isPhoneValid ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          color: Colors.red,
          message:
              'Veuillez saisir un numéro, un email et un mot de passe valides',
          iconData: Icons.close,
        ),
      );
      return;
    }

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          color: Colors.red,
          message: 'Veuillez saisir une adresse email valide',
          iconData: Icons.close,
        ),
      );
      return;
    }

    context.read<LoginBloc>().add(
      SignUpEvent(phoneNumber: phoneNumber!, email: email, password: password),
    );
    phoneNumberFocusNode.unfocus();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
  }
}
