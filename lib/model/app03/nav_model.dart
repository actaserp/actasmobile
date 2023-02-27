import 'dart:convert';

import 'package:actasm/ui/home/tab_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class NavListItem {
  final String title;
  final IconData icon;
  final WidgetBuilder page;

  NavListItem({required this.title, required this.icon, required this.page});
}

final List<NavListItem> items = [
  NavListItem(
    title: '왜 안바뀜?',
    icon: Icons.ac_unit,
    page: (context) => TabHomePage(),
  ),
  NavListItem(
    title: '두 번째 아이템',
    icon: Icons.access_alarm,
    page: (context) => TabHomePage(),
  ),
  NavListItem(
    title: '세 번째 아이템',
    icon: Icons.accessibility_new,
    page: (context) => TabHomePage(),
  ),
  NavListItem(
    title: '네 번째 아이템',
    icon: Icons.accessibility_new,
    page: (context) => TabHomePage(),
  ),
  NavListItem(
    title: '다섯 번째 아이템',
    icon: Icons.logout,
    page: (context) => TabHomePage(),
  ),
];