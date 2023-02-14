import 'dart:convert';
// import 'dart:js';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app03/MhmanualList_model.dart';

import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;



import '../tab_home.dart';
import 'appPage03_Edetail.dart';
import 'appPage03_detail.dart';

class AppPage03view extends StatefulWidget {
  final MhmanualList_model MhData;
  const AppPage03view({Key? key, required this.MhData}) : super(key: key);

  @override
  _AppPage03ViewState createState() => _AppPage03ViewState();
}

class _AppPage03ViewState extends State<AppPage03view> {

  String? _MHhgpTxt;

  //if hseq = hseq 일때, set해주기.
  // String toString()=> 'Weather for ${MhData ?? 'dd'}';

  @override
  void initState() {
    super.initState();
    // widget.MhData.hgroupcd = _MHhgpTxt;

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
          '수리노하우',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        // bottom: _reusableWidget.bottomAppBar(),
      ),
      body:
     ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('${MhData}', style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: SOFT_BLUE
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
                  child: Text('hsubject', style: TextStyle(
                      fontSize:14, fontWeight: FontWeight.bold, color: CHARCOAL
                  )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text('hpernm', style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold, color: SOFT_BLUE
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
                  child: Text('hmemo', style: TextStyle(
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
                  child: Text('첨부파일리스트', style: TextStyle(
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

            // child:  ListView.builder(
            //       shrinkWrap: true,
            //       itemCount: 1,
            //       // physics: NeverScrollableScrollPhysics(),
            //       itemBuilder: (BuildContext context, int index) {
            //         return _veiwdetail(MhData[index]);
            //       },
            //     ),
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
          // children: List.generate(shoppingCartData.length,(index){
          // return _buildItem(index, boxImageSize);
          // }),
        ),
      )
    ],
  );
}

  Widget _veiwdetail(MhmanualList_model MhData){
    return  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text('${MhData.hsubject}', style: TextStyle(
                    fontSize:14, fontWeight: FontWeight.bold, color: CHARCOAL
                )),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text('${MhData.hpernm}', style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold, color: SOFT_BLUE
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
                child: Text('${MhData.hmemo}', style: TextStyle(
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
                child: Text('첨부파일리스트', style: TextStyle(
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

    );

  }
}