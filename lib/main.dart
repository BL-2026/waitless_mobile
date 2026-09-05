import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:waitless_mobile/src/config/router.dart';
import 'package:waitless_mobile/src/domain/entities/app_language.dart';
import 'package:waitless_mobile/src/presentation/cubits/language/language_cubit.dart';
import 'package:waitless_mobile/src/services/injection_container.dart' as di;
import 'package:waitless_mobile/src/utils/constants/strings.dart';
import 'package:waitless_mobile/src/utils/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  final languageCubit = di.sl<LanguageCubit>();
  await languageCubit.load();
  runApp(MainApp(languageCubit: languageCubit));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.languageCubit});

  final LanguageCubit languageCubit;
  static final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: languageCubit,
      child: BlocBuilder<LanguageCubit, AppLanguage>(
        builder: (context, language) {
          final isAuthenticated = FirebaseAuth.instance.currentUser != null;
          return MaterialApp(
            navigatorKey: _navigatorKey,
            locale: language.locale,
            supportedLocales: AppLanguage.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: 'Waitless',
            theme: AppTheme.light(),
            initialRoute:
                isAuthenticated ? routeNamePinPage : routeNameLanguage,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
