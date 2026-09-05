import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/config/app_localizations.dart';
import 'package:waitless_mobile/src/presentation/cubits/auth/logout/logout_cubit.dart';
import 'package:waitless_mobile/src/utils/constants/colors.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? refreshFunction;
  final Function()? filterFunction;

  const MainAppBar({
    super.key,
    required this.title,
    required this.logoutCubit,
    this.refreshFunction,
    this.filterFunction,
  });

  final String title;
  final LogoutCubit logoutCubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppBar(
      leadingWidth: 150,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(
            'assets/images/auth_logo.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      title: Text(
        title,
      ),
      centerTitle: true,
      actions: [
        refreshFunction != null
            ? IconButton(
                onPressed: () => refreshFunction!(),
                icon: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_outlined,
                      size: 25,
                    )
                  ],
                ),
              )
            : const SizedBox.shrink(),
        filterFunction != null
            ? IconButton(
                onPressed: () => filterFunction!(),
                icon: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.filter_list,
                      size: 25,
                    )
                  ],
                ),
              )
            : const SizedBox.shrink(),
        IconButton(
          onPressed: () async {
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  l10n.logoutTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  l10n.logoutConfirm,
                  style: const TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                    ),
                    child: Text(l10n.cancel),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(green),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(l10n.yes),
                  ),
                ],
              ),
            );
            if (shouldLogout == true) {
              logoutCubit.logout();
            }
          },
          icon: const Icon(Icons.logout, size: 25),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
