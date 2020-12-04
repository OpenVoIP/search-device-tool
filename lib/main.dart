import 'package:provider/provider.dart';
import 'package:search_tool/i10n/localizations.dart';
import 'package:search_tool/page/home.dart';
import 'package:flutter/material.dart';
import 'package:search_tool/utils/currentLocale.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CurrentLocale()) //此是语言状态注册
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentLocale>(builder: (context, currentLocale, child) {
      return MaterialApp(
        title: 'SeachTool',
        navigatorKey: navigatorKey,
        localizationsDelegates: [
          // 本地化代理
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
        ],
        locale: currentLocale.value, //语言设置2
        supportedLocales: [
          const Locale('zh', 'CN'), // 中文简体
          const Locale('en', 'US'), // 美国英语
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            bodyText1: TextStyle(fontSize: 14.0),
          ),
          primarySwatch: Colors.grey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      );
    });
  }
}
