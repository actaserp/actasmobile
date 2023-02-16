import 'dart:convert';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:actasm/ui/reusable/cache_image_network.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


import '../../../model/app05/SmanualList_model.dart';
import '../../../model/app05/SCmanualList_model.dart';

class AppPage05 extends StatefulWidget {
  @override
  _AppPage05State createState() => _AppPage05State();

}

class _AppPage05State extends State<AppPage05> {


  // initialize reusable widget
  final _reusableWidget = ReusableWidget();
  final List<String> _SCData = [];
late String _dbnm, _subkey;


  @override
  void initState() {
    SSlist_getdata();
    comment();
    super.initState();
  }

  @override
  Future comment()async {
     _dbnm = await  SessionManager().get("dbnm");
     _subkey = await  SessionManager().get("subkey");
    var uritxt = CLOUD_URL + '/appmobile/comslist';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'subkey': _subkey,
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      SCData.clear();
      _SCData.clear();
      for (int i = 0; i < alllist.length; i++) {
        SCmanualList_model SCObject= SCmanualList_model(
          custcd:alllist[i]['custcd'],
          spjangcd:alllist[i]['spjangcd'],
          sseq:alllist[i]['sseq'],
          sinputdate:alllist[i]['sinputdate'],
          spernm:alllist[i]['spernm'],
          smemo:alllist[i]['smemo'],
          sflag:alllist[i]['sflag'],
          subkey:alllist[i]['subkey'],
        );
        setState(() {
          SCData.add(SCObject);
          _SCData.add(alllist[i]['sseq'] + '[' + alllist[i]['sinputdate'] + ']' + alllist[i]['spernm'] + ']'  + alllist[i]['smemo'] + ']' + alllist[i]['sflag'] + ']' + alllist[i]['subkey'] + ']');

        });

      }
      return SCData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future SSlist_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/SSlist';
    var encoded = Uri.encodeFull(uritxt);

    Uri uri = Uri.parse(encoded);
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      SData.clear();
      for (int i = 0; i < alllist.length; i++) {
        SmanualList_model SObject= SmanualList_model(
          custcd:alllist[i]['custcd'],
          spjangcd:alllist[i]['spjangcd'],
          sseq:alllist[i]['sseq'],
          sinputdate:alllist[i]['sinputdate'],
          spernm:alllist[i]['spernm'],
          smemo:alllist[i]['smemo'],
          sflag:alllist[i]['sflag'],
          subkey:alllist[i]['subkey'],
        );
        setState(() {
          SData.add(SObject);
        });

      }
      return SData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
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
            '수리 Q&A',
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          bottom: _reusableWidget.bottomAppBar(),
        ),
        body:ListView(
                padding: EdgeInsets.all(16),
                  children: [
                    Container(
                      child: Text('수리 Q&A 게시판', style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
                      )),
                    ),
                  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xffcccccc),
                                width: 1.0,
                              ),
                              bottom: BorderSide(
                                color: Color(0xffcccccc),
                                width: 1.0,
                              ),
                            ),
                          ),
                          width: 750,
                          height: 750,
                          child:
                           ListView.builder(
                            shrinkWrap: true,
                            itemCount: SData.length,
                            itemBuilder: (BuildContext context, int index) {
                            return _buildHEAD(SData[index]);
                            },
                          ),
                        ),
                      ),
                   ],
              ),
    );
  }

  Widget _buildHEAD(SmanualList_model SData){
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Container(
      margin: EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Color(0xffcccccc),
              width: 1.5
          ),
        ),
      ),
      child: Row(
        children: [
          Center(
            child: Text('${SData.sinputdate}', style: TextStyle(
                color: SOFT_GREY, fontSize: 11
            )),
          ),
          SizedBox(
            width: 130,
          ),
          Center(
            child: Text('${SData.spernm}', style: TextStyle(
                color: SOFT_BLUE, fontWeight: FontWeight.bold, fontSize: 11
            )),
          ),
          Center(
            child: Text('님이 작성한 질문입니다.', style: TextStyle(
                color: SOFT_GREY, fontSize: 11
            )),
          ),
        ],
      ),
    ),
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffcccccc),
                width: 1.0,
              ),
              color:  Color(0xfff9fafd),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding:EdgeInsets.all(16),
                      child: Text('내용: ${SData.smemo}', style: TextStyle(
                          fontSize:11, fontWeight: FontWeight.bold, color: SOFT_BLUE
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
                ListView.builder(
                itemCount: _SCData.length,
                itemBuilder: (BuildContext context, int index) {
                return _buildchat(SCData[index]);
                },
                ),

                ],
      );

  }


  //gray 게시글 if~~~~ admin이 아니라면~
  Widget _buildchat(SCmanualList_model SCData){
    final double boxChatSize = MediaQuery.of(context).size.width/1.3;
    return Container(
      margin:EdgeInsets.only(top: 4),
      child:
          Container(
            constraints: BoxConstraints(maxWidth: boxChatSize),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Colors.grey[300]!
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(12),
                ),
                color: Colors.grey[300]
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [

                Flexible(

                  child: Text('${SCData.smemo}', style: TextStyle(
                      color: CHARCOAL
                  )),
                ),
                Wrap(
                  children: [
                    SizedBox(width: 4),
                    Icon(Icons.done_all, color: SOFT_BLUE, size: 11),
                    SizedBox(width: 2),
                    Text('${SCData.sinputdate}', style: TextStyle(
                        color: SOFT_GREY, fontSize: 9
                    )),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildChatSeller(String message, String date){
    final double boxChatSize = MediaQuery.of(context).size.width/1.3;
    return Container(
      margin:EdgeInsets.only(top: 4),
      child:
          Container(
              constraints: BoxConstraints(maxWidth: boxChatSize),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: Colors.grey[300]!
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(5),
                  )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(message, style: TextStyle(
                        color: CHARCOAL
                    )),
                  ),
                  Wrap(
                    children: [
                      SizedBox(width: 2),
                      Text(date, style: TextStyle(
                          color: SOFT_GREY, fontSize: 9
                      )),
                    ],
                  )
                ],
              )
      ),
    );
  }


}
