import 'package:flutter/material.dart';
import 'package:waitless_mobile/src/presentation/widgets/shared/snackbars/custom_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

bool isValidEmail(String email) {
  // Regular expression for validating an Email
  String p =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = RegExp(p);
  return regExp.hasMatch(email);
}

Map<String, dynamic>? getTotalPrice(List<Map<String, dynamic>>? prices) {
  if (prices != null) {
    for (var i = 0; i < prices.length; i++) {
      if (prices[i]["scope"] == "TOTAL") return prices[i];
    }
  }
  return null;
}

Map<String, dynamic>? getTotalBasePrice(List<Map<String, dynamic>>? prices) {
  if (prices != null) {
    for (var i = 0; i < prices.length; i++) {
      if (prices[i]["scope"] == "TOTAL_BASE") return prices[i];
    }
  }
  return null;
}

Map<String, dynamic>? getBasePrice(List<Map<String, dynamic>>? prices) {
  if (prices != null) {
    for (var i = 0; i < prices.length; i++) {
      if (prices[i]["scope"] == "BASE") return prices[i];
    }
  }
  return null;
}

Map<String, dynamic>? getUnitPrice(List<Map<String, dynamic>>? prices) {
  if (prices != null) {
    for (var i = 0; i < prices.length; i++) {
      if (prices[i]["scope"] == "UNIT") return prices[i];
    }
  }
  return null;
}

Map<String, dynamic>? getUnitBasePrice(List<Map<String, dynamic>>? prices) {
  if (prices != null) {
    for (var i = 0; i < prices.length; i++) {
      if (prices[i]["scope"] == "UNIT_BASE") return prices[i];
    }
  }
  return null;
}

Future<void> launchURL(String url, BuildContext context, String message) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
      color: Colors.red,
      message: message,
      iconData: Icons.close,
    ));
  }
}

Future<void> launchDocument(String url, BuildContext context) async {
  url = Uri.encodeFull(url);
  await launchURL(url, context, "Erreur! Impossible de lancer le document");
}

String createAuditMessageForClient(String soldeInitial, String soldeUsed,
    String orderId, String generatedSolde, String newSolde, String currency) {
  return "Solde Initial: $soldeInitial $currency, Solde utiliser: $soldeUsed $currency, La commande N°$orderId génère $generatedSolde $currency de remise, nouveau solde: $newSolde $currency";
}

String createAuditMessageForSupplier(
    String orderId,
    String createdFrom,
    String orderTotalPrice,
    String currency,
    String generatedSolde,
    String appFees,
    String retocomission) {
  return "Commande N°$orderId du $createdFrom pour $orderTotalPrice $currency | remise: $generatedSolde $currency | Frais cagnotte: $appFees $currency | retrocommisions: $retocomission $currency";
}

String getIsoCodeFromDialCode(String dialCode) {
  const Map<String, String> dialCodeToIso = {
    '+1': 'US',
    '+7': 'RU',
    '+20': 'EG',
    '+27': 'ZA',
    '+30': 'GR',
    '+31': 'NL',
    '+32': 'BE',
    '+33': 'FR',
    '+34': 'ES',
    '+36': 'HU',
    '+39': 'IT',
    '+40': 'RO',
    '+41': 'CH',
    '+43': 'AT',
    '+44': 'GB',
    '+45': 'DK',
    '+46': 'SE',
    '+47': 'NO',
    '+48': 'PL',
    '+49': 'DE',
    '+51': 'PE',
    '+52': 'MX',
    '+53': 'CU',
    '+54': 'AR',
    '+55': 'BR',
    '+56': 'CL',
    '+57': 'CO',
    '+58': 'VE',
    '+60': 'MY',
    '+61': 'AU',
    '+62': 'ID',
    '+63': 'PH',
    '+64': 'NZ',
    '+65': 'SG',
    '+66': 'TH',
    '+81': 'JP',
    '+82': 'KR',
    '+84': 'VN',
    '+86': 'CN',
    '+90': 'TR',
    '+91': 'IN',
    '+92': 'PK',
    '+93': 'AF',
    '+94': 'LK',
    '+95': 'MM',
    '+98': 'IR',
    '+211': 'SS',
    '+212': 'MA', // Morocco
    '+213': 'DZ',
    '+216': 'TN',
    '+218': 'LY',
    '+220': 'GM',
    '+221': 'SN',
    '+222': 'MR',
    '+223': 'ML',
    '+224': 'GN',
    '+225': 'CI',
    '+226': 'BF',
    '+227': 'NE',
    '+228': 'TG',
    '+229': 'BJ',
    '+230': 'MU',
    '+231': 'LR',
    '+232': 'SL',
    '+233': 'GH',
    '+234': 'NG',
    '+235': 'TD',
    '+236': 'CF',
    '+237': 'CM',
    '+238': 'CV',
    '+239': 'ST',
    '+240': 'GQ',
    '+241': 'GA',
    '+242': 'CG',
    '+243': 'CD',
    '+244': 'AO',
    '+245': 'GW',
    '+246': 'IO',
    '+248': 'SC',
    '+249': 'SD',
    '+250': 'RW',
    '+251': 'ET',
    '+252': 'SO',
    '+253': 'DJ',
    '+254': 'KE',
    '+255': 'TZ',
    '+256': 'UG',
    '+257': 'BI',
    '+258': 'MZ',
    '+260': 'ZM',
    '+261': 'MG',
    '+262': 'RE', // Réunion (primary)
    '+263': 'ZW',
    '+264': 'NA',
    '+265': 'MW',
    '+266': 'LS',
    '+267': 'BW',
    '+268': 'SZ',
    '+269': 'YT', // Mayotte (different from +262 RE)
    '+290': 'SH',
    '+291': 'ER',
    '+297': 'AW',
    '+298': 'FO',
    '+299': 'GL',
    '+350': 'GI',
    '+351': 'PT',
    '+352': 'LU',
    '+353': 'IE',
    '+354': 'IS',
    '+355': 'AL',
    '+356': 'MT',
    '+357': 'CY',
    '+358': 'FI',
    '+359': 'BG',
    '+370': 'LT',
    '+371': 'LV',
    '+372': 'EE',
    '+373': 'MD',
    '+374': 'AM',
    '+375': 'BY',
    '+376': 'AD',
    '+377': 'MC',
    '+378': 'SM',
    '+380': 'UA',
    '+381': 'RS',
    '+382': 'ME',
    '+383': 'XK',
    '+385': 'HR',
    '+386': 'SI',
    '+387': 'BA',
    '+389': 'MK',
    '+420': 'CZ',
    '+421': 'SK',
    '+423': 'LI',
    '+500': 'FK',
    '+501': 'BZ',
    '+502': 'GT',
    '+503': 'SV',
    '+504': 'HN',
    '+505': 'NI',
    '+506': 'CR',
    '+507': 'PA',
    '+508': 'PM',
    '+509': 'HT',
    '+590': 'GP',
    '+591': 'BO',
    '+592': 'GY',
    '+593': 'EC',
    '+594': 'GF',
    '+595': 'PY',
    '+596': 'MQ',
    '+597': 'SR',
    '+598': 'UY',
    '+599': 'CW',
    '+670': 'TL',
    '+672': 'NF',
    '+673': 'BN',
    '+674': 'NR',
    '+675': 'PG',
    '+676': 'TO',
    '+677': 'SB',
    '+678': 'VU',
    '+679': 'FJ',
    '+680': 'PW',
    '+681': 'WF',
    '+682': 'CK',
    '+683': 'NU',
    '+685': 'WS',
    '+686': 'KI',
    '+687': 'NC',
    '+688': 'TV',
    '+689': 'PF',
    '+690': 'TK',
    '+691': 'FM',
    '+692': 'MH',
  };

  return dialCodeToIso[dialCode] ?? 'FR';
}

bool isImage(String url) {
  return url.endsWith('.jpg') ||
      url.endsWith('.jpeg') ||
      url.endsWith('.png') ||
      url.endsWith('.gif');
}
