import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latex_toolbox/page/convert_page.dart';
import 'package:latex_toolbox/page/home_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.setTitle('LaTeX toolbox');

  if (Platform.isWindows) {
    await windowManager.setMinimumSize(const Size(500, 600));
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LaTeX Converter',
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      initialRoute: '/',
      getPages: [HomePage(), ConvertPage()],
      defaultTransition: Transition.native,
    );
  }
}
