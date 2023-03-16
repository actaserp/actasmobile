import 'dart:ui';
import 'package:actasm/ui/home/app5Home/appPager13.dart';
import 'package:actasm/config/constant.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:actasm/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {


 /// this function makes application always run in portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  // await Permission.storage.request();
  ///onsignal function
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("2f677e4f-4e90-439b-84af-29c8f75ba1e8");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  getID();
  // print('OneSignal Player ID: $getID');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });

}

Future<String> getID() async {
  var userId;
  // Get the user's OneSignal Player ID
  String? playerId = await OneSignal.shared.getDeviceState().then((state) => state?.userId);
  print('pushid check ::: ${playerId}');

  // Save the playerId to SharedPreferences
  await savePlayerId(playerId!);

  return playerId;
}

Future<void> savePlayerId(String playerId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('playerId', playerId);
  print('localstorage check ::: ${playerId}');
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

