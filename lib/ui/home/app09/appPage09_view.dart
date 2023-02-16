import 'dart:convert';
// import 'dart:js';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app04/MmanualList_model.dart';

import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../model/app04/EmanualList_model.dart';
import '../tab_home.dart';

class AppPage09view extends StatefulWidget {
  final EmanualList_model EData;
  const AppPage09view({Key? key, required this.EData}) : super(key: key);

  @override
  _AppPage09viewState createState() => _AppPage09viewState();
}

class _AppPage09viewState extends State<AppPage09view> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text(
          '기타자료실',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        // bottom: _reusableWidget.bottomAppBar(),
      ),
      body:
      ListView(
        padding: EdgeInsets.all(26),
        children: [
          Text('No.${widget.EData.eseq}', style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: CHARCOAL
          )),
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffcccccc),
                width: 1.0,
              ),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  child: Text('제목 : ${widget.EData.esubject}', style: TextStyle(
                      fontSize:16, fontWeight: FontWeight.bold, color: SOFT_BLUE
                  )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text('분류 : ${widget.EData.cnam}', style: TextStyle(
                      fontSize:13, fontWeight: FontWeight.bold
                  )),
                ),
                Container(
                  child: Row(
                    children: [
                      Text('작성자 : ${widget.EData.epernm}',style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold
                      ))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xffcccccc),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text('${widget.EData.ememo}', style: TextStyle(
                      fontSize: 14, color: CHARCOAL
                  )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xffcccccc),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text('첨부파일리스트(${widget.EData.attcnt}개)', style: TextStyle(
                      fontSize:13, fontWeight: FontWeight.bold, color: CHARCOAL
                  )),
                ),
                SizedBox(
                  height: 12,
                ),
                _buildFileList(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),

        ],
      ),
    );

  }


//첨부파일리스트
  Widget _buildFileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(

          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox( //왼쪽 크기 정하기
                    width: 0,
                    height: 40,
                  ),
                  Text('첨부파일 목록', style: TextStyle(
                      fontSize: 20,
                      color: SOFT_BLUE,
                      fontWeight: FontWeight.bold
                  ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ], //row-childeren
          ),
        )
      ],
    );
  }

}