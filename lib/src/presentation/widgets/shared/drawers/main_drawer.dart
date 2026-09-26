import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/utils/helpers/failure_messages.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/logout/logout_cubit.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/brand_mark.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/snackbars/custom_snack_bar.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/spinners/custom_loading_indicator.dart';
import 'package:waitless_mobile/src/services/shared_preferences_service.dart';
import 'package:waitless_mobile/src/utils/constants/app_colors.dart';
import 'package:waitless_mobile/src/utils/constants/strings.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String? email;
  late LogoutCubit _logoutCubit;
  bool _myUserLoading = false;

  @override
  void initState() {
    _logoutCubit = context.read<LogoutCubit>();
    _loadUserData();
    super.initState();
  }

  Future<void> _loadUserData() async {
    setState(() => _myUserLoading = true);
    final myUser = await SharedPreferencesService.getUser();
    setState(() {
      email = myUser.email;
      _myUserLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Drawer(
      backgroundColor: AppColors.canvas,
      child: !_myUserLoading
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BrandMark(compact: true),
                    const SizedBox(height: 28),
                    Text(
                      l10n.staffAccess,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _DrawerTile(
                      icon: Icons.language_outlined,
                      label: l10n.language,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, routeNameLanguage);
                      },
                    ),
                    _DrawerTile(
                      icon: Icons.logout_rounded,
                      label: l10n.logout,
                      onTap: () => _logoutCubit.logout(),
                    ),
                    const Spacer(),
                    BlocConsumer<LogoutCubit, LogoutState>(
                      builder: (context, state) => const SizedBox.shrink(),
                      listener: (context, state) {
                        if (state is LogoutInProgress) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.surface,
                              content: CustomLoadingIndicator(text: l10n.loading),
                            ),
                          );
                        } else if (state is LogoutFailure) {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => AppAlert(
                              title: l10n.error,
                              content: context.l10n.messageFor(state.failure),
                              actionLabel: l10n.ok,
                            ),
                          );
                        } else if (state is LogoutSuccess) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                              color: AppColors.sage,
                              message: l10n.loggedOut,
                              iconData: Icons.check,
                            ),
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            routeNameLanguage,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          : CustomLoadingIndicator(text: l10n.loading),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.espresso),
      title: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
