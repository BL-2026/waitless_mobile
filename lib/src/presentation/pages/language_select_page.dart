import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/domain/entities/app_language.dart';
import 'package:waitless_mobile/src/presentation/cubits/language/language_cubit.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/brand_mark.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/primary_button.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/constants/strings.dart';
import 'package:waitless_mobile/src/utils/theme/app_theme.dart';

class LanguageSelectPage extends StatefulWidget {
  const LanguageSelectPage({super.key});

  @override
  State<LanguageSelectPage> createState() => _LanguageSelectPageState();
}

class _LanguageSelectPageState extends State<LanguageSelectPage> {
  late AppLanguage _selected;

  @override
  void initState() {
    super.initState();
    _selected = context.read<LanguageCubit>().state;
  }

  Future<void> _continue() async {
    await context.read<LanguageCubit>().setLanguage(_selected);
    if (!mounted) return;

    final isAuthenticated = FirebaseAuth.instance.currentUser != null;
    if (isAuthenticated) {
      Navigator.of(context).maybePop();
    } else {
      Navigator.pushReplacementNamed(context, routeNameAuthLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isAuthenticated = FirebaseAuth.instance.currentUser != null;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: isAuthenticated
          ? AppBar(
              title: Text(l10n.language),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isAuthenticated) ...[
                const BrandMark(),
                const SizedBox(height: 36),
              ],
              Text(l10n.chooseLanguage, style: AppTheme.display(30)),
              const SizedBox(height: 10),
              Text(
                l10n.languageSubtitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.muted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  itemCount: AppLanguage.values.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final language = AppLanguage.values[index];
                    final selected = language == _selected;
                    return Material(
                      color: selected ? AppColors.espresso : AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        onTap: () {
                          setState(() => _selected = language);
                          context.read<LanguageCubit>().setLanguage(language);
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected ? AppColors.espresso : AppColors.line,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                language.flag,
                                style: const TextStyle(fontSize: 26),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  language.nativeName,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? Colors.white
                                        : AppColors.espresso,
                                  ),
                                ),
                              ),
                              Icon(
                                selected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: selected
                                    ? AppColors.gold
                                    : AppColors.line,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              PrimaryButton(
                label: l10n.continueLabel,
                onPressed: _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
