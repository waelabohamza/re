import 'package:adminyaser/pages/auth/login.dart';
import 'package:adminyaser/pages/home/home.dart';
import 'package:adminyaser/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

var userid;
SharedPreferences sharedPrefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  userid = sharedPrefs.getString("id");
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: Locale("ar"),
      title: 'Almutjar AlArabi',
      routes: routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline2: TextStyle(fontSize: 20)
        )
      ),
      home: userid != null ? Home() : Login(),
    );
  }
}
