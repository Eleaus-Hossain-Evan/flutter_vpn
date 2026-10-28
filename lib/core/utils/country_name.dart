import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/widgets.dart';

/// Display name of the country with ISO 3166-1 alpha-2 [isoCode].
///
/// country_code_picker's base names are native ("Deutschland", "日本"), so the
/// name comes from its localizations. Its `translate()` stringifies entries
/// that hold several names (US, GB) into "[…, …]"; those fall back to the
/// base name, which is English for them ("United States", "United Kingdom").
String countryName(BuildContext context, String isoCode) {
  final code = isoCode.toUpperCase();
  final localized = CountryLocalizations.of(context)?.translate(code);
  if (localized != null && !localized.startsWith('[')) return localized;
  return CountryCode.tryFromCountryCode(code)?.name ?? code;
}
