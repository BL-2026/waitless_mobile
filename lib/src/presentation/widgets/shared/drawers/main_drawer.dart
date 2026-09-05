import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/logout/logout_cubit.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/snackbars/custom_snack_bar.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/spinners/custom_loading_indicator.dart';
import 'package:waitless_mobile/src/services/shared_preferences_service.dart';
import 'package:waitless_mobile/src/utils/constants/colors.dart';
import 'package:waitless_mobile/src/utils/constants/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    setState(() {
      _myUserLoading = true;
    });
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
      child: !_myUserLoading
          ? ListView(
              children: [
                Column(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: const Text(
                        '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      accountEmail: Text(
                        email ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      currentAccountPicture: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey.shade100,
                        child: const Icon(Icons.person, color: Color(green)),
                      ),
                      decoration: const BoxDecoration(color: Color(green)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(
                        l10n.language,
                        style: const TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, routeNameLanguage);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: Text(
                        l10n.logout,
                        style: const TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        _logoutCubit.logout();
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                    const Divider(color: Colors.black),
                    BlocConsumer<LogoutCubit, LogoutState>(
                      builder: (context, state) => const SizedBox(),
                      listener: (context, state) {
                        if (state is LogoutInProgress) {
                          showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                              content: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state is LogoutFailure) {
                          Navigator.pop(context); // Close the loading
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(l10n.error),
                              content: Text(state.errorMessage),
                            ),
                          );
                        } else if (state is LogoutSuccess) {
                          Navigator.pop(context); // Close the loading
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                              color: Colors.green,
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
              ],
            )
          : CustomLoadingIndicator(text: l10n.loading),
    );
  }
}
