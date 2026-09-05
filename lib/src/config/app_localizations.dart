import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitless_mobile/src/domain/entities/app_language.dart';
import 'package:waitless_mobile/src/presentation/cubits/language/language_cubit.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations(read<LanguageCubit>().state);
}

class AppLocalizations {
  const AppLocalizations(this._language);

  final AppLanguage _language;

  String _t(Map<AppLanguage, String> values) =>
      values[_language] ?? values[AppLanguage.en]!;

  String get chooseLanguage => _t(const {
        AppLanguage.en: 'Choose your language',
        AppLanguage.fr: 'Choisissez votre langue',
        AppLanguage.ar: 'اختر لغتك',
        AppLanguage.es: 'Elige tu idioma',
      });

  String get languageSubtitle => _t(const {
        AppLanguage.en: 'You can change this later from the menu.',
        AppLanguage.fr: 'Vous pourrez la modifier plus tard depuis le menu.',
        AppLanguage.ar: 'يمكنك تغييرها لاحقًا من القائمة.',
        AppLanguage.es: 'Podrás cambiarlo más tarde desde el menú.',
      });

  String get continueLabel => _t(const {
        AppLanguage.en: 'Continue',
        AppLanguage.fr: 'Continuer',
        AppLanguage.ar: 'متابعة',
        AppLanguage.es: 'Continuar',
      });

  String get email => _t(const {
        AppLanguage.en: 'Email',
        AppLanguage.fr: 'Email',
        AppLanguage.ar: 'البريد الإلكتروني',
        AppLanguage.es: 'Correo electrónico',
      });

  String get password => _t(const {
        AppLanguage.en: 'Password',
        AppLanguage.fr: 'Mot de passe',
        AppLanguage.ar: 'كلمة المرور',
        AppLanguage.es: 'Contraseña',
      });

  String get forgotPassword => _t(const {
        AppLanguage.en: 'Forgot password?',
        AppLanguage.fr: 'Mot de passe oublié?',
        AppLanguage.ar: 'هل نسيت كلمة المرور؟',
        AppLanguage.es: '¿Olvidaste tu contraseña?',
      });

  String get forgotPasswordTitle => _t(const {
        AppLanguage.en: 'Forgot password',
        AppLanguage.fr: 'Mot de passe oublié',
        AppLanguage.ar: 'نسيت كلمة المرور',
        AppLanguage.es: 'Contraseña olvidada',
      });

  String get enterCredentials => _t(const {
        AppLanguage.en: 'Please enter your credentials.',
        AppLanguage.fr: 'Veuillez saisir vos identifiants.',
        AppLanguage.ar: 'يرجى إدخال بيانات الدخول.',
        AppLanguage.es: 'Introduce tus credenciales.',
      });

  String get signIn => _t(const {
        AppLanguage.en: 'Sign in',
        AppLanguage.fr: 'Se connecter',
        AppLanguage.ar: 'تسجيل الدخول',
        AppLanguage.es: 'Iniciar sesión',
      });

  String get noAccount => _t(const {
        AppLanguage.en: "Don't have an account? ",
        AppLanguage.fr: "Vous n'avez pas de compte ? ",
        AppLanguage.ar: 'ليس لديك حساب؟ ',
        AppLanguage.es: '¿No tienes una cuenta? ',
      });

  String get signUp => _t(const {
        AppLanguage.en: 'Sign up',
        AppLanguage.fr: "S'inscrire",
        AppLanguage.ar: 'إنشاء حساب',
        AppLanguage.es: 'Registrarse',
      });

  String get loggedIn => _t(const {
        AppLanguage.en: 'You are signed in',
        AppLanguage.fr: 'Vous êtes connecté',
        AppLanguage.ar: 'تم تسجيل الدخول',
        AppLanguage.es: 'Has iniciado sesión',
      });

  String get error => _t(const {
        AppLanguage.en: 'Error',
        AppLanguage.fr: 'Erreur',
        AppLanguage.ar: 'خطأ',
        AppLanguage.es: 'Error',
      });

  String get accountCreated => _t(const {
        AppLanguage.en: 'Congratulations, your account was created successfully',
        AppLanguage.fr: 'Félicitations, votre compte a été créé avec succès',
        AppLanguage.ar: 'تهانينا، تم إنشاء حسابك بنجاح',
        AppLanguage.es: 'Enhorabuena, tu cuenta se creó correctamente',
      });

  String get alreadyHaveAccount => _t(const {
        AppLanguage.en: 'Already have an account? ',
        AppLanguage.fr: 'Vous avez déjà un compte ? ',
        AppLanguage.ar: 'هل لديك حساب بالفعل؟ ',
        AppLanguage.es: '¿Ya tienes una cuenta? ',
      });

  String get fillValidFields => _t(const {
        AppLanguage.en: 'Please enter a valid phone number, email and password',
        AppLanguage.fr:
            'Veuillez saisir un numéro, un email et un mot de passe valides',
        AppLanguage.ar: 'يرجى إدخال رقم هاتف وبريد إلكتروني وكلمة مرور صالحة',
        AppLanguage.es:
            'Introduce un teléfono, un correo y una contraseña válidos',
      });

  String get invalidEmail => _t(const {
        AppLanguage.en: 'Please enter a valid email address',
        AppLanguage.fr: 'Veuillez saisir une adresse email valide',
        AppLanguage.ar: 'يرجى إدخال بريد إلكتروني صالح',
        AppLanguage.es: 'Introduce una dirección de correo válida',
      });

  String get forgotPasswordHint => _t(const {
        AppLanguage.en: 'Please enter your email to reset your password',
        AppLanguage.fr:
            'S\'il vous plaît, entrez votre email pour réinitialiser votre mot de passe',
        AppLanguage.ar: 'يرجى إدخال بريدك الإلكتروني لإعادة تعيين كلمة المرور',
        AppLanguage.es: 'Introduce tu correo para restablecer tu contraseña',
      });

  String get enterEmail => _t(const {
        AppLanguage.en: 'Please enter an email',
        AppLanguage.fr: 'Veuillez entrer un email',
        AppLanguage.ar: 'يرجى إدخال بريد إلكتروني',
        AppLanguage.es: 'Introduce un correo electrónico',
      });

  String get submit => _t(const {
        AppLanguage.en: 'Submit',
        AppLanguage.fr: 'Soumettre',
        AppLanguage.ar: 'إرسال',
        AppLanguage.es: 'Enviar',
      });

  String get checkEmail => _t(const {
        AppLanguage.en: 'Please check your email',
        AppLanguage.fr: 'Veuillez vérifier votre email',
        AppLanguage.ar: 'يرجى التحقق من بريدك الإلكتروني',
        AppLanguage.es: 'Revisa tu correo electrónico',
      });

  String get loading => _t(const {
        AppLanguage.en: 'Loading...',
        AppLanguage.fr: 'Chargement...',
        AppLanguage.ar: 'جارٍ التحميل...',
        AppLanguage.es: 'Cargando...',
      });

  String get hi => _t(const {
        AppLanguage.en: 'Hi',
        AppLanguage.fr: 'Bonjour',
        AppLanguage.ar: 'مرحبًا',
        AppLanguage.es: 'Hola',
      });

  String get enterPin => _t(const {
        AppLanguage.en: 'Enter your 4-digit PIN',
        AppLanguage.fr: 'Entrez votre code PIN à 4 chiffres',
        AppLanguage.ar: 'أدخل رمز PIN المكون من 4 أرقام',
        AppLanguage.es: 'Introduce tu PIN de 4 dígitos',
      });

  String get incorrectPin => _t(const {
        AppLanguage.en: 'Incorrect PIN, try again',
        AppLanguage.fr: 'Code PIN incorrect, réessayez',
        AppLanguage.ar: 'رمز PIN غير صحيح، حاول مرة أخرى',
        AppLanguage.es: 'PIN incorrecto, inténtalo de nuevo',
      });

  String get openMenu => _t(const {
        AppLanguage.en: 'Open menu',
        AppLanguage.fr: 'Ouvrir le menu',
        AppLanguage.ar: 'فتح القائمة',
        AppLanguage.es: 'Abrir menú',
      });

  String get activeRequests => _t(const {
        AppLanguage.en: 'Active requests',
        AppLanguage.fr: 'Demandes actives',
        AppLanguage.ar: 'الطلبات النشطة',
        AppLanguage.es: 'Solicitudes activas',
      });

  String get allCaughtUp => _t(const {
        AppLanguage.en: 'All caught up',
        AppLanguage.fr: 'Tout est à jour',
        AppLanguage.ar: 'لا توجد طلبات',
        AppLanguage.es: 'Todo al día',
      });

  String get emptyQueueHint => _t(const {
        AppLanguage.en: 'New requests from tables will appear here instantly.',
        AppLanguage.fr:
            'Les nouvelles demandes des tables apparaîtront ici instantanément.',
        AppLanguage.ar: 'ستظهر هنا طلبات الطاولات الجديدة فورًا.',
        AppLanguage.es:
            'Las nuevas solicitudes de las mesas aparecerán aquí al instante.',
      });

  String table(int number) => _t({
        AppLanguage.en: 'Table $number',
        AppLanguage.fr: 'Table $number',
        AppLanguage.ar: 'طاولة $number',
        AppLanguage.es: 'Mesa $number',
      });

  String get callWaiter => _t(const {
        AppLanguage.en: 'Call waiter',
        AppLanguage.fr: 'Appeler le serveur',
        AppLanguage.ar: 'استدعاء النادل',
        AppLanguage.es: 'Llamar al camarero',
      });

  String get requestingBill => _t(const {
        AppLanguage.en: 'Requesting the bill',
        AppLanguage.fr: 'Demande d\'addition',
        AppLanguage.ar: 'طلب الفاتورة',
        AppLanguage.es: 'Pidiendo la cuenta',
      });

  String requestingBillWithMethod(String method) => _t({
        AppLanguage.en: 'Requesting the bill · $method',
        AppLanguage.fr: 'Demande d\'addition · $method',
        AppLanguage.ar: 'طلب الفاتورة · $method',
        AppLanguage.es: 'Pidiendo la cuenta · $method',
      });

  String get justNow => _t(const {
        AppLanguage.en: 'just now',
        AppLanguage.fr: 'à l\'instant',
        AppLanguage.ar: 'الآن',
        AppLanguage.es: 'ahora mismo',
      });

  String minutesAgo(int minutes) => _t({
        AppLanguage.en: '$minutes min ago',
        AppLanguage.fr: 'il y a $minutes min',
        AppLanguage.ar: 'منذ $minutes د',
        AppLanguage.es: 'hace $minutes min',
      });

  String hoursAgo(int hours) => _t({
        AppLanguage.en: '$hours hr ago',
        AppLanguage.fr: 'il y a $hours h',
        AppLanguage.ar: 'منذ $hours س',
        AppLanguage.es: 'hace $hours h',
      });

  String get acknowledge => _t(const {
        AppLanguage.en: 'Acknowledge',
        AppLanguage.fr: 'Accuser réception',
        AppLanguage.ar: 'تأكيد الاستلام',
        AppLanguage.es: 'Reconocer',
      });

  String get resolve => _t(const {
        AppLanguage.en: 'Resolve',
        AppLanguage.fr: 'Résoudre',
        AppLanguage.ar: 'إنهاء',
        AppLanguage.es: 'Resolver',
      });

  String get logout => _t(const {
        AppLanguage.en: 'Log out',
        AppLanguage.fr: 'Déconnecter',
        AppLanguage.ar: 'تسجيل الخروج',
        AppLanguage.es: 'Cerrar sesión',
      });

  String get loggedOut => _t(const {
        AppLanguage.en: 'You have been logged out',
        AppLanguage.fr: 'Vous vous êtes déconnecté',
        AppLanguage.ar: 'تم تسجيل الخروج',
        AppLanguage.es: 'Has cerrado sesión',
      });

  String get language => _t(const {
        AppLanguage.en: 'Language',
        AppLanguage.fr: 'Langue',
        AppLanguage.ar: 'اللغة',
        AppLanguage.es: 'Idioma',
      });

  String get logoutTitle => _t(const {
        AppLanguage.en: 'Log out',
        AppLanguage.fr: 'Déconnexion',
        AppLanguage.ar: 'تسجيل الخروج',
        AppLanguage.es: 'Cerrar sesión',
      });

  String get logoutConfirm => _t(const {
        AppLanguage.en: 'Are you sure you want to log out?',
        AppLanguage.fr: 'Êtes-vous sûr de vouloir vous déconnecter ?',
        AppLanguage.ar: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
        AppLanguage.es: '¿Seguro que quieres cerrar sesión?',
      });

  String get cancel => _t(const {
        AppLanguage.en: 'Cancel',
        AppLanguage.fr: 'Annuler',
        AppLanguage.ar: 'إلغاء',
        AppLanguage.es: 'Cancelar',
      });

  String get yes => _t(const {
        AppLanguage.en: 'Yes',
        AppLanguage.fr: 'Oui',
        AppLanguage.ar: 'نعم',
        AppLanguage.es: 'Sí',
      });

  String get ok => _t(const {
        AppLanguage.en: 'OK',
        AppLanguage.fr: 'OK',
        AppLanguage.ar: 'حسنًا',
        AppLanguage.es: 'OK',
      });

  String get selectLocation => _t(const {
        AppLanguage.en: 'Select location',
        AppLanguage.fr: 'Sélectionner l\'emplacement',
        AppLanguage.ar: 'حدد الموقع',
        AppLanguage.es: 'Seleccionar ubicación',
      });

  String get searchPlace => _t(const {
        AppLanguage.en: 'Search for a place...',
        AppLanguage.fr: 'Rechercher un lieu...',
        AppLanguage.ar: 'ابحث عن مكان...',
        AppLanguage.es: 'Buscar un lugar...',
      });

  String get unknown => _t(const {
        AppLanguage.en: 'Unknown',
        AppLanguage.fr: 'Inconnu',
        AppLanguage.ar: 'غير معروف',
        AppLanguage.es: 'Desconocido',
      });
}
