import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/domain/entities/app_language.dart';
import 'package:waitless_mobile/src/services/shared_preferences_service.dart';

class LanguageCubit extends Cubit<AppLanguage> {
  LanguageCubit() : super(AppLanguage.fr);

  Future<void> load() async {
    final code = await SharedPreferencesService.getLanguageCode();
    emit(AppLanguage.fromCode(code));
  }

  Future<void> setLanguage(AppLanguage language) async {
    await SharedPreferencesService.setLanguageCode(language.code);
    emit(language);
  }
}
