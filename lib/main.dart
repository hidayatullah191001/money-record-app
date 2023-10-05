import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/session.dart';
import 'package:getx_money_record_app/presentation/page/auth/login_page.dart';
import 'package:getx_money_record_app/presentation/page/home_page.dart';
import 'package:intl/date_symbol_data_file.dart';

import 'config/app_color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: AppColor.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.secondary,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.primary, foregroundColor: Colors.white),
      ),
      home: FutureBuilder(
        future: Session.getUser(),
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.name != null) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
