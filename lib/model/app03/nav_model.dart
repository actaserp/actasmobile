import 'dart:convert';

import 'package:actasm/ui/home/tab_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';
import '../../ui/authentication/signin.dart';


class NavListItem {
  final String title;
  final IconData icon;
  final WidgetBuilder page;
  final Future<void> Function(BuildContext)? logout;

  NavListItem({required this.title, required this.icon, required this.page, this.logout});

}

final List<NavListItem> items = [
  NavListItem(
    title: 'Home',
    icon: Icons.ac_unit,
    page: (context) => TabHomePage(),
  ),
  NavListItem(
    title: '고장처리',
    icon: Icons.access_alarm,
    page: (context) => TabHomePage(),
  ),
  NavListItem(
    title: '현장정보',
    icon: Icons.accessibility_new,
    page: (context) => TabHomePage(),
  ),
  NavListItem(
    title: 'My page',
    icon: Icons.accessibility_new,
    page: (context) => TabHomePage(),
  ),
  NavListItem(
    title: 'test',
    icon: Icons.logout,
    page: (context) => TabHomePage(),
    logout: (context) async {
      await SessionManager().destroy();
      Navigator.pushNamedAndRemoveUntil(context, '/SigninPage', (route) => false);
    },
    /// try1
    // logout: (context) async {
    //   // 로그아웃 처리 로직 작성
    //   // 예를 들어, 세션 삭제
    //   await SessionManager().destroy();
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, '/login', (route) => false);
    // },
  ),
];