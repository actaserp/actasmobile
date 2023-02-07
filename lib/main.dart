import 'dart:ui';

import 'package:actasm/config/constant.dart';

import 'package:actasm/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {

  // this function makes application always run in portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MyApp());
  });
}

class MyCustomeScrollBehavior extends MaterialScrollBehavior{
  @override
  Set<PointerDeviceKind> get dragDevices =>{
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse
  };
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      builder: (context, widget) {
        Widget error = const
        Text(
          '예외오류가 발생했습니다. 이전버튼을 클릭하세요.',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 20, color: Colors.white),
        );
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(body: Center(child: error));
        }
        ErrorWidget.builder = (errorDetails) => error;
        if (widget != null) return widget;
        throw ('widget is null');
      },
      scrollBehavior: MyCustomeScrollBehavior(),
      title: APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS : CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder()
         }),
        ),
       home: SplashScreenPage(),
      );
  }


}

