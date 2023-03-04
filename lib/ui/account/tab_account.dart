/*
This is account page
we used AutomaticKeepAliveClientMixin to keep the state when moving from 1 navbar to another navbar, so the page is not refresh overtime
 */

import 'dart:convert';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/ui/account/account_information/account_information.dart';
import 'package:actasm/ui/account/last_seen_product.dart';
import 'package:actasm/ui/home/app03/Nav_right.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:actasm/ui/reusable/cache_image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TabAccountPage extends StatefulWidget {
  @override
  _TabAccountPageState createState() => _TabAccountPageState();
}

class _TabAccountPageState extends State<TabAccountPage> with AutomaticKeepAliveClientMixin {
  // initialize reusable widget
  final _reusableWidget = ReusableWidget();
  ///작성자
  var _usernm = "";
  var _userid = "";
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    sessionData();
    super.initState();
  }
  @override
  Future<void> sessionData() async {
    String username = await  SessionManager().get("username");
    _usernm = utf8.decode(username.runes.toList());
    String userid = await  SessionManager().get("userid");
    _userid = utf8.decode(userid.runes.toList());

  }
  @override
  Widget build(BuildContext context) {
    // if we used AutomaticKeepAliveClientMixin, we must call super.build(context);
    super.build(context);
    return Scaffold(
        endDrawer: Nav_right(
          text: Text('acc_nav'),
          color: SOFT_BLUE,
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: GlobalStyle.appBarIconThemeColor,
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'Account',
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [

            _createAccountInformation(),
            Container(
              margin: EdgeInsets.fromLTRB(0, 18, 0, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(_usernm, style: TextStyle(
                      fontSize: 15, color: CHARCOAL,
                  )),
                  // Icon(Icons.chevron_right, size: 20, color: SOFT_GREY),
                ],
              ),
            ),

            _reusableWidget.divider1(),
            Container(
              margin: EdgeInsets.fromLTRB(0, 18, 0, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(_userid, style: TextStyle(
                      fontSize: 15, color: SOFT_BLUE, fontWeight: FontWeight.bold
                  )),
                  Text( ' 님이 접속 중입니다.',
                    style: TextStyle(color: BLACK_GREY ,fontSize: 15),
                  ),
                  // Icon(Icons.chevron_right, size: 20, color: SOFT_GREY),
                ],
              ),
            ),
            _reusableWidget.divider1(),

            // Container(
            //   margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
            //   child: GestureDetector(
            //     behavior: HitTestBehavior.translucent,
            //     onTap: (){
            //       Fluttertoast.showToast(
            //           msg: 'Click Sign Out',
            //           toastLength: Toast.LENGTH_LONG);
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.power_settings_new, size: 20, color: ASSENT_COLOR),
            //         SizedBox(width: 8),
            //         Text('Sign Out', style: TextStyle(
            //             fontSize: 15, color: ASSENT_COLOR
            //         )),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        )
    );
  }

  Widget _createAccountInformation(){
    final double profilePictureSize = MediaQuery.of(context).size.width/4;
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: profilePictureSize,
            height: profilePictureSize,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AccountInformationPage()));
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: profilePictureSize,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: profilePictureSize-4,
                  child: Hero(
                    tag: 'profilePicture2',
                    child: ClipOval(
                        child: buildCacheNetworkImage(width: profilePictureSize-4, height: profilePictureSize-4, url: GLOBAL_URL+'/user/avatar.png')
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( _usernm,
                  style: TextStyle(color: SOFT_BLUE ,fontSize: 18,fontWeight: FontWeight.bold),
                ),
                Text( '님 반갑습니다.',
                  style: TextStyle(color: BLACK_GREY ,fontSize: 18),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createListMenu(String menuTitle, StatefulWidget page){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 18, 0, 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(menuTitle, style: TextStyle(
                fontSize: 15, color: CHARCOAL
            )),
            // Icon(Icons.chevron_right, size: 20, color: SOFT_GREY),
          ],
        ),
      ),
    );
  }
}
