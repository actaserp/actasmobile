import 'dart:ui';
import 'package:actasm/ui/home/app5Home/appPager13.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:actasm/config/constant.dart';

import 'package:actasm/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadClass {
  static void callback(String id, DownloadTaskStatus status, int progress){
    print("Down Status : $status");
    print("Down Progress: $progress");
  }
}

void main() async {

 /// this function makes application always run in portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  FlutterDownloader.registerCallback(DownloadClass.callback);
  await Permission.storage.request();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {

    runApp(MyApp());
  });

///Initilaize
//   WidgetsFlutterBinding.ensureInitialized();
//     await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
//     runApp(MyApp());

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
    return GetMaterialApp(
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
      getPages: [
        GetPage(name: '/next', page: () => AppPager13())
      ],
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

