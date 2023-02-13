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

  @override
  _AppPage03ViewState createState() => _AppPage03ViewState();
}

class _AppPage03ViewState extends State<AppPage03view> {
  // 컨트롤러

  @override
  void initState() {
    super.initState();
    mhlist_getdata();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future mhlist_getdata() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/mhlist';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    // try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: <String, String>{
          'dbnm': _dbnm
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> alllist = [];
        alllist = jsonDecode(utf8.decode(response.bodyBytes));
        MhData.clear();
        for (int i = 0; i < alllist.length; i++) {
          MhmanualList_model MhObject = MhmanualList_model(
            custcd: alllist[i]['custcd'],
            spjangcd: alllist[i]['spjangcd'],
            hseq: alllist[i]['hseq'],
            hinputdate: alllist[i]['hinputdate'],
            hgroupcd: alllist[i]['hgroupcd'],
            hsubject: alllist[i]['hsubject'],
            hpernm: alllist[i]['hpernm'],
            hmemo: alllist[i]['hmemo'],
            hflag: alllist[i]['hflag'],
          );
          setState(() {
            MhData.add(MhObject);
          });
        }
        return
        MhData;

      } else {
        throw Exception('불러오는데 실패했습니다');

      }

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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('ㅇㅇ', style: TextStyle(
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
                  child: Text('글제목글제목글제목', style: TextStyle(
                      fontSize:14, fontWeight: FontWeight.bold, color: CHARCOAL
                  )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text('작성자', style: TextStyle(
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
                  child: Text('글내용글내용글내용2글내용글내용글내용2글내용글내용글내용2글내용글내용글내용2글내용글내용글내용2글내용글내용글내용2', style: TextStyle(
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
                      fontSize:14, fontWeight: FontWeight.bold, color: CHARCOAL
                  )),
                ),
                SizedBox(
                  height: 12,
                ),
                _buildFileList(),
              ],
            ),
          ),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }



void showPopupMakeDefault() {
    // set up the buttons
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('No', style: TextStyle(color: SOFT_BLUE))
    );
    Widget continueButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
          // _reusableWidget.startLoading(context, 'Success', 0);
        },
        child: Text('Yes', style: TextStyle(color: SOFT_BLUE))
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('Make Default', style: TextStyle(fontSize: 18),),
      content: Text('Are you sure to make this card as a default payment ?', style: TextStyle(fontSize: 13, color: BLACK_GREY)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showPopupDeletePayment(int index) {
    // set up the buttons
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('No', style: TextStyle(color: SOFT_BLUE))
    );
    Widget continueButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
          if(index==0){
            Fluttertoast.showToast(msg: '삭제 되었습니다.', toastLength: Toast.LENGTH_LONG);
          } else {
            // _reusableWidget.startLoading(context, 'Delete Payment Method Success', 0);
          }
        },
        child: Text('Yes', style: TextStyle(color: SOFT_BLUE))
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('수리노하우 게시글 삭제', style: TextStyle(fontSize: 18),),
      content: Text('해당 글을 삭제하시겠습니까?', style: TextStyle(fontSize: 13, color: BLACK_GREY)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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


}