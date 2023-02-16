import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
// import 'dart:js';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app03/MhmanualList_model.dart';

import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../model/app04/BmanualList_model.dart';
import '../tab_home.dart';

class AppPage04Att extends StatefulWidget {
  final BmanualList_model BData;
  const AppPage04Att({Key? key, required this.BData}) : super(key: key);

  @override
  _AppPage04AttState createState() => _AppPage04AttState();
}

class _AppPage04AttState extends State<AppPage04Att> {

  @override
  void initState() {
    super.initState();
    // FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text(
          '부품 가이드 자료실',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        // bottom: _reusableWidget.bottomAppBar(),
      ),
    );
  }

  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   print('Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
  //   final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
  //   send.send([id, status, progress]);
  // }

}