import 'dart:convert';
import 'dart:io';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/ui/home/app03/Nav_right.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:actasm/ui/reusable/cache_image_network.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


import '../../../model/app05/SmanualList_model.dart';
import '../../../model/app05/SCmanualList_model.dart';
import '../appPage02.dart';
import '../tab_home.dart';

class AppPage05 extends StatefulWidget {


  @override
  _AppPage05State createState() => _AppPage05State();

}

class _AppPage05State extends State<AppPage05> {

  TextEditingController _etSearch = TextEditingController();
  late String _dbnm;
  late Map<dynamic, dynamic> seqKey23;
  final List<String> _SCmData = [];
  final List<String> _keyData = [];
  final List<String> _seqKey = [];
  final List<String> _SCpermData = [];
  final List<String> _inData = [];


  @override
  void initState() {
    SSlist_getdata();
    attachCM();
    super.initState();
    debugPrint("keydata 조회되는지 keyData2[1] ::: ${seqKey}");
    debugPrint("keydata 조회되는지 keyData2 1,2,3 나열 ::: ${_seqKey}");


  }



  @override
  void dispose() {
    _etSearch.dispose();
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
      seqKey.clear();
      _seqKey.clear();
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
          seqKey.add(SObject);
          _seqKey.add(alllist[i]['subkey']);
        });

      }
      return SData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }

  @override
  Future attachCM()async {
    _dbnm = await  SessionManager().get("dbnm");
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
        ///data를 String으로 전달
        'dbnm': _dbnm,
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      SCmData.clear();
      _SCmData.clear();
      keyData.clear();
      _keyData.clear();

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
          SCmData.add(SCObject);
          _SCmData.add(alllist[i]['smemo']);
          SCpermData.add(SCObject);
          _SCpermData.add(alllist[i]['spernm']);
          inData.add(SCObject);
          _inData.add(alllist[i]['sinputdate']);
          keyData.add(SCObject);
          _keyData.add(alllist[i]['subkey']);
        });
      }
      debugPrint('comment data::: $SCData length::::${SCData.length}' );
      debugPrint('subkey data::: $keyData length::::${keyData.length}' );
      debugPrint('spernm data::: $SCpermData length::::${SCpermData.length}' );
      debugPrint('date data::: $inData length::::${inData.length}' );
      return
        SCData;
    }else{
      throw Exception('불러오는데 실패했습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double HSize = (MediaQuery.of(context).size.height/1.3);
    return Scaffold(
      endDrawer: Nav_right(
        text: Text('app05_nav'),
          color: SOFT_BLUE,
          ),
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
          bottom: PreferredSize(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[100]!,
                      width: 1.0,
                    )
                ),
              ),
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              height: kToolbarHeight,
              child: TextFormField(
                controller: _etSearch,
                textAlignVertical: TextAlignVertical.bottom,
                maxLines: 1,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                onChanged: (textValue) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  hintText: '질문 검색',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  suffixIcon: (_etSearch.text == '')
                      ? null
                      : GestureDetector(
                      onTap: () {
                        setState(() {
                          _etSearch = TextEditingController(text: '');
                        });
                      },
                      child: Icon(Icons.close, color: Colors.grey[500])),
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.grey[200]!)),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(kToolbarHeight),
          ),
        ),
        body:ListView(
                padding: EdgeInsets.all(16),
                  children: [
                    Container(
                      child: Text('수리 Q&A 게시판  ${SData.length} 건', style: TextStyle(
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
                          height: HSize,
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
    final double WidthSize = (MediaQuery.of(context).size.width*1);
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Container(
                  width: WidthSize,
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
                        width: WidthSize/55,
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

                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                Container(
                  height: MediaQuery.of(context).size.height/7,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: SCData.length,
                    itemBuilder: (BuildContext context, int index) {
                    Iterable<String> commap = seqKey.where((element) => element == SCData[index]).cast<String>();
                    debugPrint("맵 결과 (2) ::: ${commap}");
                      return
                        _buildchat(SCData[index]);
                    },
                  ),
                ),

                ],
      );

  }



  ///모델 가져가고
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
