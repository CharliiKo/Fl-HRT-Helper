import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'controlPage.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Fl HRT Helper';
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CH'), // 中文简体
        Locale('zh', 'HK'), // 中文繁体
        Locale('jp', 'JP'), // 日语
        Locale('en', 'US'), // 英语
      ],
      locale: const Locale('zh', 'CH'), // 设置默认语言为中文
      home: ControlPage(title: appTitle)
    );
  }
}







