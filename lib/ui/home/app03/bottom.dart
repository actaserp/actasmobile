import 'package:actasm/ui/account/tab_account.dart';
import 'package:actasm/ui/home/app03/appPage03.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../app5Home/appPager11.dart';
import '../appPage02.dart';
import '../tab_home.dart';


///예시임 직접 위젯 만들어서 Navigator로 새로고침 페이지 바꾸는걸 권장

class Bottom extends StatefulWidget{
  //
  // final Widget Function(BuildContext) builder;
  //
  // Bottom({Key? key, required this.builder}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  // final Widget text;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 0) { // 1번째 아이템을 눌렀을 때
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AppPage03()));
        }
        if (index == 1) { // 2번째 아이템을 눌렀을 때
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => TabHomePage()));
        } // Page3 페이지로 이동

        if (index == 2) { // 3번째 아이템을 눌렀을 때
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => TabAccountPage()));        }
      },
      items: [
                    BottomNavigationBarItem(
                    icon: Icon(Icons.refresh),
                    label: '상단으로',
                    ),
                    BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                    ),
                    BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                    ),
        ],
    );
  }
}