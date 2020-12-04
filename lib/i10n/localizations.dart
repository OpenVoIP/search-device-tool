import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((b) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get tip1 {
    return Intl.message(
      'Device search does not support cross-network segment',
    );
  }

  String get tip2 {
    return Intl.message(
      'Please click here to download and install WinPcap',
    );
  }

  String get saveTo {
    return Intl.message(
      'Save to',
    );
  }

  String get dowload {
    return Intl.message(
      'Download',
    );
  }

  String get submit {
    return Intl.message(
      'Submit',
    );
  }

  String get mask {
    return Intl.message(
      'Subnet Mask',
    );
  }

  String get router {
    return Intl.message(
      'Router',
    );
  }

  String get close {
    return Intl.message(
      'Close',
    );
  }

  String get setting {
    return Intl.message(
      'Setting',
    );
  }

  String get onlineTotal {
    return Intl.message(
      'Online Total',
    );
  }

  String get export {
    return Intl.message(
      'Export',
    );
  }

  String get refresh {
    return Intl.message(
      'Refresh',
    );
  }

  String get serchByMac {
    return Intl.message(
      'Search By Mac',
    );
  }

  String get number {
    return Intl.message(
      'Number',
    );
  }

  String get language {
    return Intl.message(
      'Language',
    );
  }

  String get model {
    return Intl.message(
      'Model',
    );
  }

  String get name {
    return Intl.message(
      'Name',
    );
  }

  String get company {
    return Intl.message(
      'Company',
    );
  }

  String get password {
    return Intl.message(
      "Password",
    );
  }

  String get adminPassword {
    return Intl.message(
      "Admin Password",
    );
  }
}

//Locale代理类
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  // 当Localizations Widget重新build时，是否调用load重新加载Locale资源.
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
