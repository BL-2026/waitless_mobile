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
    AppLanguage.en: 'For the floor team across Morocco.',
    AppLanguage.fr: 'Pour l’équipe en salle, partout au Maroc.',
    AppLanguage.ar: 'لفريق الخدمة في جميع أنحاء المغرب.',
    AppLanguage.es: 'Para el equipo de sala en Marruecos.',
  });

  String get staffAccess => _t(const {
    AppLanguage.en: 'Staff access',
    AppLanguage.fr: 'Accès équipe',
    AppLanguage.ar: 'دخول الموظفين',
    AppLanguage.es: 'Acceso del personal',
  });

  String get staffTagline => _t(const {
    AppLanguage.en: 'Tables call. You answer.',
    AppLanguage.fr: 'Les tables appellent. Vous répondez.',
    AppLanguage.ar: 'الطاولات تنادي. وأنت تجيب.',
    AppLanguage.es: 'Las mesas llaman. Tú respondes.',
  });

  String get venueName => _t(const {
    AppLanguage.en: 'Café Atlas',
    AppLanguage.fr: 'Café Atlas',
    AppLanguage.ar: 'مقهى أطلس',
    AppLanguage.es: 'Café Atlas',
  });

  String get floorLive => _t(const {
    AppLanguage.en: 'Live floor',
    AppLanguage.fr: 'Salle en direct',
    AppLanguage.ar: 'القاعة مباشرة',
    AppLanguage.es: 'Sala en vivo',
  });

  String waitingCount(int count) => _t({
    AppLanguage.en: '$count waiting',
    AppLanguage.fr: '$count en attente',
    AppLanguage.ar: '$count في الانتظار',
    AppLanguage.es: '$count en espera',
  });

  String get allZones => _t(const {
    AppLanguage.en: 'All zones',
    AppLanguage.fr: 'Toutes les zones',
    AppLanguage.ar: 'كل المناطق',
    AppLanguage.es: 'Todas las zonas',
  });

  String get onMyWay => _t(const {
    AppLanguage.en: 'On my way',
    AppLanguage.fr: 'J’arrive',
    AppLanguage.ar: 'في الطريق',
    AppLanguage.es: 'Voy en camino',
  });

  String get done => _t(const {
    AppLanguage.en: 'Done',
    AppLanguage.fr: 'Terminé',
    AppLanguage.ar: 'تم',
    AppLanguage.es: 'Listo',
  });

  String get pinUnlock => _t(const {
    AppLanguage.en: 'Unlock the floor',
    AppLanguage.fr: 'Déverrouiller la salle',
    AppLanguage.ar: 'فتح القاعة',
    AppLanguage.es: 'Desbloquear la sala',
  });

  String zoneName(String zone) {
    switch (zone) {
      case 'terrace':
        return _t(const {
          AppLanguage.en: 'Terrace',
          AppLanguage.fr: 'Terrasse',
          AppLanguage.ar: 'الشرفة',
          AppLanguage.es: 'Terraza',
        });
      case 'salon':
        return _t(const {
          AppLanguage.en: 'Salon',
          AppLanguage.fr: 'Salon',
          AppLanguage.ar: 'الصالون',
          AppLanguage.es: 'Salón',
        });
      case 'patio':
        return _t(const {
          AppLanguage.en: 'Patio',
          AppLanguage.fr: 'Patio',
          AppLanguage.ar: 'الفناء',
          AppLanguage.es: 'Patio',
        });
      case 'lounge':
        return _t(const {
          AppLanguage.en: 'Lounge',
          AppLanguage.fr: 'Lounge',
          AppLanguage.ar: 'اللاونج',
          AppLanguage.es: 'Lounge',
        });
      default:
        return zone;
    }
  }

  String get continueLabel => _t(const {
    AppLanguage.en: 'Continue',
    AppLanguage.fr: 'Continuer',
    AppLanguage.ar: 'متابعة',
    AppLanguage.es: 'Continuar',
  });

  String get fullName => _t(const {
    AppLanguage.en: 'Full name',
    AppLanguage.fr: 'Nom complet',
    AppLanguage.ar: 'الاسم الكامل',
    AppLanguage.es: 'Nombre completo',
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

  String get continueWithGoogle => _t(const {
    AppLanguage.en: 'Continue with Google',
    AppLanguage.fr: 'Continuer avec Google',
    AppLanguage.ar: 'المتابعة عبر Google',
    AppLanguage.es: 'Continuar con Google',
  });

  String get orLabel => _t(const {
    AppLanguage.en: 'or',
    AppLanguage.fr: 'ou',
    AppLanguage.ar: 'أو',
    AppLanguage.es: 'o',
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

  String get networkUnreachable => _t(const {
        AppLanguage.en:
            'Something went wrong. Please try again.',
        AppLanguage.fr:
            'Une erreur est survenue. Veuillez réessayer.',
        AppLanguage.ar:
            'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
        AppLanguage.es:
            'Algo salió mal. Por favor, inténtalo de nuevo.',
      });

  String get serverError => _t(const {
        AppLanguage.en: 'The server is temporarily unavailable. Please try again.',
        AppLanguage.fr:
            'Le serveur est temporairement indisponible. Veuillez réessayer.',
        AppLanguage.ar: 'الخادم غير متاح مؤقتاً. يرجى المحاولة مرة أخرى.',
        AppLanguage.es:
            'El servidor no está disponible temporalmente. Inténtalo de nuevo.',
      });

  String get unexpectedError => _t(const {
        AppLanguage.en: 'Something went wrong. Please try again.',
        AppLanguage.fr: 'Une erreur est survenue. Veuillez réessayer.',
        AppLanguage.ar: 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
        AppLanguage.es: 'Algo ha salido mal. Inténtalo de nuevo.',
      });

  String get notFoundError => _t(const {
        AppLanguage.en: 'We could not find what you asked for.',
        AppLanguage.fr: 'Impossible de trouver ce que vous demandez.',
        AppLanguage.ar: 'تعذر العثور على ما طلبته.',
        AppLanguage.es: 'No hemos encontrado lo que pediste.',
      });

  String get badRequestError => _t(const {
        AppLanguage.en: 'Some details look wrong. Please check and try again.',
        AppLanguage.fr:
            'Certaines informations semblent incorrectes. Vérifiez et réessayez.',
        AppLanguage.ar: 'بعض التفاصيل غير صحيحة. يرجى التحقق والمحاولة مرة أخرى.',
        AppLanguage.es:
            'Algunos datos parecen incorrectos. Revísalos e inténtalo de nuevo.',
      });

  String get forbiddenError => _t(const {
        AppLanguage.en: 'You do not have permission to do that.',
        AppLanguage.fr: 'Vous n’avez pas l’autorisation de faire cela.',
        AppLanguage.ar: 'ليس لديك صلاحية للقيام بذلك.',
        AppLanguage.es: 'No tienes permiso para hacer eso.',
      });

  String get conflictError => _t(const {
        AppLanguage.en: 'This conflicts with existing data. Please try again.',
        AppLanguage.fr:
            'Cela entre en conflit avec des données existantes. Réessayez.',
        AppLanguage.ar: 'هذا يتعارض مع بيانات موجودة. يرجى المحاولة مرة أخرى.',
        AppLanguage.es:
            'Esto entra en conflicto con datos existentes. Inténtalo de nuevo.',
      });

  String get sessionExpired => _t(const {
        AppLanguage.en: 'Your session expired. Please sign in again.',
        AppLanguage.fr: 'Votre session a expiré. Veuillez vous reconnecter.',
        AppLanguage.ar: 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.',
        AppLanguage.es: 'Tu sesión ha caducado. Vuelve a iniciar sesión.',
      });

  String get invalidCredentials => _t(const {
        AppLanguage.en: 'Incorrect email or password.',
        AppLanguage.fr: 'Email ou mot de passe incorrect.',
        AppLanguage.ar: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
        AppLanguage.es: 'Correo o contraseña incorrectos.',
      });

  String get emailAlreadyInUse => _t(const {
        AppLanguage.en: 'An account already exists with this email.',
        AppLanguage.fr: 'Un compte existe déjà avec cet email.',
        AppLanguage.ar: 'يوجد حساب بالفعل بهذا البريد الإلكتروني.',
        AppLanguage.es: 'Ya existe una cuenta con este correo.',
      });

  String get weakPassword => _t(const {
        AppLanguage.en: 'Please choose a stronger password.',
        AppLanguage.fr: 'Veuillez choisir un mot de passe plus fort.',
        AppLanguage.ar: 'يرجى اختيار كلمة مرور أقوى.',
        AppLanguage.es: 'Elige una contraseña más segura.',
      });

  String get invalidEmail => _t(const {
        AppLanguage.en: 'Please enter a valid email address.',
        AppLanguage.fr: 'Veuillez saisir une adresse email valide.',
        AppLanguage.ar: 'يرجى إدخال بريد إلكتروني صالح.',
        AppLanguage.es: 'Introduce un correo electrónico válido.',
      });

  String get googleSignInFailed => _t(const {
        AppLanguage.en: 'Google sign-in failed. Please try again.',
        AppLanguage.fr: 'La connexion Google a échoué. Veuillez réessayer.',
        AppLanguage.ar: 'فشل تسجيل الدخول عبر Google. يرجى المحاولة مرة أخرى.',
        AppLanguage.es: 'Falló el inicio de sesión con Google. Inténtalo de nuevo.',
      });

  String get passwordResetFailed => _t(const {
        AppLanguage.en: 'We could not send the reset email. Please try again.',
        AppLanguage.fr:
            'Impossible d’envoyer l’email de réinitialisation. Réessayez.',
        AppLanguage.ar: 'تعذر إرسال بريد إعادة التعيين. يرجى المحاولة مرة أخرى.',
        AppLanguage.es:
            'No pudimos enviar el correo de restablecimiento. Inténtalo de nuevo.',
      });

  String get logoutFailed => _t(const {
        AppLanguage.en: 'Could not sign out. Please try again.',
        AppLanguage.fr: 'Impossible de se déconnecter. Veuillez réessayer.',
        AppLanguage.ar: 'تعذر تسجيل الخروج. يرجى المحاولة مرة أخرى.',
        AppLanguage.es: 'No se pudo cerrar sesión. Inténtalo de nuevo.',
      });

  String get tooManyAttempts => _t(const {
        AppLanguage.en: 'Too many attempts. Please wait a moment and try again.',
        AppLanguage.fr:
            'Trop de tentatives. Attendez un instant et réessayez.',
        AppLanguage.ar: 'محاولات كثيرة جداً. انتظر قليلاً ثم حاول مرة أخرى.',
        AppLanguage.es:
            'Demasiados intentos. Espera un momento e inténtalo de nuevo.',
      });

  String get accountDisabled => _t(const {
        AppLanguage.en: 'This account has been disabled.',
        AppLanguage.fr: 'Ce compte a été désactivé.',
        AppLanguage.ar: 'تم تعطيل هذا الحساب.',
        AppLanguage.es: 'Esta cuenta ha sido desactivada.',
      });

  String get liveUpdatesDisconnected => _t(const {
        AppLanguage.en: 'Live updates disconnected. Reconnecting…',
        AppLanguage.fr: 'Mises à jour en direct coupées. Reconnexion…',
        AppLanguage.ar: 'انقطع التحديث المباشر. جارٍ إعادة الاتصال…',
        AppLanguage.es: 'Actualizaciones en vivo desconectadas. Reconectando…',
      });

  String get liveUpdatesUnauthorized => _t(const {
        AppLanguage.en: 'Live updates were rejected. Please sign in again.',
        AppLanguage.fr:
            'Les mises à jour en direct ont été refusées. Reconnectez-vous.',
        AppLanguage.ar: 'تم رفض التحديث المباشر. يرجى تسجيل الدخول مرة أخرى.',
        AppLanguage.es:
            'Se rechazaron las actualizaciones en vivo. Vuelve a iniciar sesión.',
      });

  String get liveSyncFailed => _t(const {
        AppLanguage.en: 'Could not sync the live queue. Please try again.',
        AppLanguage.fr:
            'Impossible de synchroniser la file en direct. Réessayez.',
        AppLanguage.ar: 'تعذر مزامنة قائمة الانتظار المباشرة. حاول مرة أخرى.',
        AppLanguage.es:
            'No se pudo sincronizar la cola en vivo. Inténtalo de nuevo.',
      });

  String get noVenueSelected => _t(const {
        AppLanguage.en: 'No venue selected.',
        AppLanguage.fr: 'Aucun établissement sélectionné.',
        AppLanguage.ar: 'لم يتم اختيار أي مكان.',
        AppLanguage.es: 'No hay local seleccionado.',
      });

  String get staffPinRequired => _t(const {
        AppLanguage.en: 'Enter your PIN first.',
        AppLanguage.fr: 'Saisissez d’abord votre code PIN.',
        AppLanguage.ar: 'أدخل رمز PIN أولاً.',
        AppLanguage.es: 'Introduce primero tu PIN.',
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
    AppLanguage.en:
        'Please enter your name, a valid phone number, email and password',
    AppLanguage.fr: 'Veuillez saisir votre nom, un numéro, un email et un mot de passe valides',
    AppLanguage.ar: 'يرجى إدخال اسمك ورقم هاتف وبريد إلكتروني وكلمة مرور صالحة',
    AppLanguage.es:
        'Introduce tu nombre, un teléfono, un correo y una contraseña válidos',
  });

  String get forgotPasswordHint => _t(const {
    AppLanguage.en: 'Please enter your email to reset your password',
    AppLanguage.fr: 'S\'il vous plaît, entrez votre email pour réinitialiser votre mot de passe',
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
    AppLanguage.en: 'Enter your 4-digit staff PIN',
    AppLanguage.fr: 'Entrez votre code PIN à 4 chiffres',
    AppLanguage.ar: 'أدخل رمز PIN للموظفين',
    AppLanguage.es: 'Introduce tu PIN de 4 dígitos',
  });

  String get incorrectPin => _t(const {
    AppLanguage.en: 'Incorrect PIN, try again',
    AppLanguage.fr: 'Code PIN incorrect, réessayez',
    AppLanguage.ar: 'رمز PIN غير صحيح، حاول مرة أخرى',
    AppLanguage.es: 'PIN incorrecto, inténtalo de nuevo',
  });

  String get chooseStaff => _t(const {
    AppLanguage.en: 'Who is on shift?',
    AppLanguage.fr: 'Qui est en service ?',
    AppLanguage.ar: 'من في الخدمة؟',
    AppLanguage.es: '¿Quién está de turno?',
  });

  String get noStoreYet => _t(const {
    AppLanguage.en: 'No venue is linked to this account yet',
    AppLanguage.fr: 'Aucun établissement n’est lié à ce compte',
    AppLanguage.ar: 'لا يوجد محل مرتبط بهذا الحساب بعد',
    AppLanguage.es: 'Aún no hay ningún local vinculado a esta cuenta',
  });

  String get noStaffYet => _t(const {
    AppLanguage.en: 'No staff member has been added to this venue yet',
    AppLanguage.fr: 'Aucun membre de l’équipe n’a encore été ajouté',
    AppLanguage.ar: 'لم تتم إضافة أي موظف إلى هذا المحل بعد',
    AppLanguage.es: 'Todavía no se ha añadido personal a este local',
  });

  String get retry => _t(const {
    AppLanguage.en: 'Try again',
    AppLanguage.fr: 'Réessayer',
    AppLanguage.ar: 'أعد المحاولة',
    AppLanguage.es: 'Reintentar',
  });

  /// Maps the backend's `PaymentMethod` enum onto something a human reads.
  String paymentMethodName(String method) => switch (method.toUpperCase()) {
    'CARD' => _t(const {
      AppLanguage.en: 'Card',
      AppLanguage.fr: 'Carte',
      AppLanguage.ar: 'بطاقة',
      AppLanguage.es: 'Tarjeta',
    }),
    'CASH' => _t(const {
      AppLanguage.en: 'Cash',
      AppLanguage.fr: 'Espèces',
      AppLanguage.ar: 'نقدًا',
      AppLanguage.es: 'Efectivo',
    }),
    _ => method,
  };

  String get openMenu => _t(const {
    AppLanguage.en: 'Open menu',
    AppLanguage.fr: 'Ouvrir le menu',
    AppLanguage.ar: 'فتح القائمة',
    AppLanguage.es: 'Abrir menú',
  });

  String get activeRequests => _t(const {
    AppLanguage.en: 'Floor calls',
    AppLanguage.fr: 'Appels en salle',
    AppLanguage.ar: 'نداءات القاعة',
    AppLanguage.es: 'Llamadas de sala',
  });

  String get floorCallsChannelDescription => _t(const {
    AppLanguage.en: 'A table is calling or asking for the bill',
    AppLanguage.fr: 'Une table appelle ou demande l’addition',
    AppLanguage.ar: 'طاولة تستدعي أو تطلب الحساب',
    AppLanguage.es: 'Una mesa llama o pide la cuenta',
  });

  String get notificationBrand => _t(const {
    AppLanguage.en: 'Floorcall',
    AppLanguage.fr: 'Floorcall',
    AppLanguage.ar: 'Floorcall',
    AppLanguage.es: 'Floorcall',
  });

  String tableCalling(int number) => _t({
    AppLanguage.en: 'Table $number is calling',
    AppLanguage.fr: 'La table $number appelle',
    AppLanguage.ar: 'الطاولة $number تستدعي',
    AppLanguage.es: 'La mesa $number está llamando',
  });

  String tableWantsBill(int number) => _t({
    AppLanguage.en: 'Table $number wants the bill',
    AppLanguage.fr: 'La table $number demande l’addition',
    AppLanguage.ar: 'الطاولة $number تطلب الحساب',
    AppLanguage.es: 'La mesa $number pide la cuenta',
  });

  String tableWantsBillWithMethod(int number, String method) => _t({
    AppLanguage.en: 'Table $number wants the bill · $method',
    AppLanguage.fr: 'La table $number demande l’addition · $method',
    AppLanguage.ar: 'الطاولة $number تطلب الحساب · $method',
    AppLanguage.es: 'La mesa $number pide la cuenta · $method',
  });

  String newCallsCount(int count) => _t({
    AppLanguage.en: '$count new calls',
    AppLanguage.fr: '$count nouveaux appels',
    AppLanguage.ar: '$count نداءات جديدة',
    AppLanguage.es: '$count llamadas nuevas',
  });

  String get allCaughtUp => _t(const {
    AppLanguage.en: 'The floor is calm',
    AppLanguage.fr: 'La salle est calme',
    AppLanguage.ar: 'القاعة هادئة',
    AppLanguage.es: 'La sala está tranquila',
  });

  String get emptyQueueHint => _t(const {
    AppLanguage.en: 'When a guest scans the table QR, the call appears here.',
    AppLanguage.fr:
        'Quand un client scanne le QR de la table, l’appel apparaît ici.',
    AppLanguage.ar: 'عندما يمسح الضيف رمز الطاولة، يظهر النداء هنا.',
    AppLanguage.es:
        'Cuando un cliente escanea el QR de la mesa, la llamada aparece aquí.',
  });

  String get tableLabel => _t(const {
    AppLanguage.en: 'Table',
    AppLanguage.fr: 'Table',
    AppLanguage.ar: 'طاولة',
    AppLanguage.es: 'Mesa',
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
    AppLanguage.en: 'On my way',
    AppLanguage.fr: 'J’arrive',
    AppLanguage.ar: 'في الطريق',
    AppLanguage.es: 'Voy en camino',
  });

  String get resolve => _t(const {
    AppLanguage.en: 'Done',
    AppLanguage.fr: 'Terminé',
    AppLanguage.ar: 'تم',
    AppLanguage.es: 'Listo',
  });

  String get endShift => _t(const {
    AppLanguage.en: 'End shift',
    AppLanguage.fr: 'Terminer le service',
    AppLanguage.ar: 'إنهاء الخدمة',
    AppLanguage.es: 'Terminar turno',
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
