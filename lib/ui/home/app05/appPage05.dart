import 'dart:convert';
import 'dart:io';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app03/nav_model.dart';
import 'package:actasm/ui/account/tab_account.dart';
import 'package:actasm/ui/home/app03/Nav_right.dart';
import 'package:actasm/ui/home/app05/appPage05_view.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:actasm/ui/reusable/cache_image_network.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


import '../../../model/app05/SmanualList_model.dart';
import '../../../model/app05/SCmanualList_model.dart';
import '../../../model/chat_model.dart';
import '../appPage02.dart';
import '../tab_home.dart';

class AppPage05 extends StatefulWidget {

  @override
  _AppPage05State createState() => _AppPage05State();

}

class _AppPage05State extends State<AppPage05> {
  final _reusableWidget = ReusableWidget();

  String? _searchText;

  TextEditingController _etSearch = TextEditingController();
  TextEditingController _etMemo = TextEditingController();
  TextEditingController _etMemo2 = TextEditingController();
  var nullableBool = "";
  var _usernm = "";
  late String _dbnm;
  @override
  void initState() {

    sessionData();
    SSlist_getdata();
    attachCM();
    super.initState();

  }

  @override
  Future<void> sessionData() async {
    String username = await  SessionManager().get("username");
    _usernm = utf8.decode(username.runes.toList());
  }


  @override
  void dispose() {
    _etSearch.dispose();
    super.dispose();
  }

  //저장
  @override
  Future<bool> save_mhdata()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/saveeSS';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("@@@@@@@@@@@수리노하우 저장@@@@@@@@@@@@@@@@");
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        ///저장시 필수 값
        ///sseq, sinputdate, smemo, spernm,
        ///custcd, spjangcd, hseq,subkey 컨트롤러
        ///sflag 없앰
        // 'sinputdate': DateTime.now().toString(),
        'spernm': _usernm.toString(),
        'smemo': _etMemo.text.toString(),
        'sseq' : nullableBool,
        // 'subkey': dd,
      },
    );
    if(response.statusCode == 200){
      print("저장됨");
      return   true;
    }else{
      throw Exception('QnA 저장에 실패했습니다');
    }
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
      // seqKey.clear();
      // _seqKey.clear();
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
          // seqKey.add(SObject);
          // _seqKey.add(alllist[i]['sseq']);
        });

      }

      return SData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }
  Future SSslist_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/SSslist';
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
        'smemo': _etSearch.text.toString(),
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      SData.clear();
      // seqKey.clear();
      // _seqKey.clear();
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
          // seqKey.add(SObject);
          // _seqKey.add(alllist[i]['sseq']);
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
        'dbnm': _dbnm,
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      SCData.clear();

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
        });
      }
      print( 'test:::: ${SCData.first.smemo}');

      return
        SCData;
    }else{
      throw Exception('수리qna를 불러오는데 실패했습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double HSize = (MediaQuery.of(context).size.height/1.3);
    int _selectedIndex = 0;
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
                decoration: InputDecoration(
                    fillColor: Colors.grey[100],
                    filled: true,
                    hintText: '질문 검색',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    focusedBorder:  UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.grey[200]!)),
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.grey[200]!) )
                ),
                onFieldSubmitted: (String? value) {
                  setState(() {
                    this._searchText = value;
                    debugPrint('텍스트 받는지 확인:::${this._searchText} ');
                    SSslist_getdata();
                  });
                },
              ),
            ),
            preferredSize: Size.fromHeight(kToolbarHeight),
          ),

        ),

        body:ListView(
          physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(12),
                  children: [
                    Container(
                      child: Text('수리 Q&A 게시판  ${SData.length} 건',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
                          )),
                    ),
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            // margin: EdgeInsets.all(20),
                            margin: EdgeInsets.only( top: 20, bottom: 10, right: 20, left: 20),
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
                            height: 300,
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
                        ///본문출력 listveiw
                        Cmemo(),
                      ],
                    ),


                   ],
        ),

      bottomNavigationBar:  BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) { // 1번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AppPage05()));          }
          if (index == 1) { // 2번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TabHomePage()));          }
          if (index == 2) { // 3번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TabAccountPage()));            }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: '새로고침',
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
      ),
    );
  }

  ///본문 입력 위젯 no data
  Widget Cmemo(){
    return   Container(
      margin: EdgeInsets.all(11),
      child: Row(
        children: [
              Flexible(
              child: TextFormField(
              controller: _etMemo,
                minLines: 1,
                maxLines: 3,
                textAlignVertical: TextAlignVertical.bottom,
                style: TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Colors.grey[500],
                  filled: true,
                  hintText: '질문을 입력해 주세요',
                  hintStyle: TextStyle(color: Colors.white),
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
            SizedBox(
            width: 10,
            ),
            Container(
            child: GestureDetector(
            onTap: ()async {
                  String inputText2 = _etMemo.text;
                  print('메시지 전송 출력 확인 => '+ inputText2);
                          showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                          title: Text('등록하시겠습니까?'),
                          actions: [
                          TextButton(
                          child: Text('취소'),
                          onPressed: () {
                          Navigator.pop(context);
                          },
                          ),
                          TextButton(
                          child: Text('등록'),
                          onPressed: () async {
                          await  save_mhdata();
                          Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => AppPage05()));
                          },
                          ),
                          ],
                          ),
                          );
                          },
            child: ClipOval(
            child: Container(
            color: SOFT_BLUE,
            padding: EdgeInsets.all(10),
            child: Icon(Icons.keyboard_arrow_up, color: Colors.white)
            ),
            ),
            ),
            ),

            ]
      )
    );
  }

     ///헤더 제작
  Widget _buildHEAD(SmanualList_model SData){
    final double WidthSize = (MediaQuery.of(context).size.width*1);
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
      children:[
                Container(
                  width: WidthSize,
                  margin: EdgeInsets.only(top:15, bottom: 15),
                  child: Row(
                    children: [
                      Center(
                        child: Text('No.${SData.sseq.toString().substring(7,9)} :: ', style: TextStyle(
                            color: SOFT_GREY, fontSize: 12
                        )),
                      ),
                      Center(
                        child: Text('${SData.sinputdate}', style: TextStyle(
                            color: SOFT_GREY, fontSize: 12
                        )),
                      ),
                      Center(
                        child: Text('  ${SData.spernm}', style: TextStyle(
                            color: SOFT_BLUE, fontWeight: FontWeight.bold, fontSize: 12
                        )),
                      ),
                      Center(
                        child: Text(' 님이 작성한 질문입니다.', style: TextStyle(
                            color: SOFT_GREY, fontSize: 12
                        )),
                      ),
                    ],
                  ),
                ),
                    Container(
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
                                width: MediaQuery.of(context).size.width/2.1,
                                padding:EdgeInsets.all(16),
                                child: Text('${SData.smemo}', style: TextStyle(
                                    fontSize:14, fontWeight: FontWeight.bold, color: SOFT_BLUE
                                )),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                Container(
                  margin: EdgeInsets.only(top:10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/12,
                  child: ListView.builder(
                    itemCount: SCData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final SCmanualList_model SCmemo = SCData[index];
                      final sseqlist = SData.sseq;
                      final subkeylist = SCmemo.subkey;
                      if (subkeylist == sseqlist) {
                        return _buildchat(SCData[index]);
                      } else {
                        return SizedBox.shrink();
                      }
                    }
                  ),
                ),
                  ///댓글입력 토글
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AppPage05view(SData: SData)));
                      },
                    child: ClipOval(
                    child: Container(
                    color: SOFT_GREY,
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.comment, color: Colors.white)
                    ),
                    ),
                    ),
                ],
      );

  }

  ///댓글 리스트 생성
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
                Container(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text('${SCData.spernm}  ', style: TextStyle(
                      color: SOFT_BLUE, fontWeight: FontWeight.bold
                  )),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text('${SCData.smemo}', style: TextStyle(
                      color: CHARCOAL
                  )),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Wrap(
                      children: [
                        SizedBox(width: 4),
                        Icon(Icons.done_all, color: SOFT_BLUE, size: 11),
                        SizedBox(width: 2),
                        Text('${SCData.sinputdate}', style: TextStyle(
                            color: SOFT_GREY, fontSize: 9
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  ///댓글 팝업
  // Future _Comment() {
  //   _inputco.clear(); // 컨트롤러 이전 값 초기화
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('수리 Q&A 댓글 입력창'),
  //         content: TextField(
  //           controller: _inputco,
  //           decoration: InputDecoration(hintText: '댓글을 입력해주세요.'),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('취소'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text('확인'),
  //             onPressed: () {
  //               String inputText = _inputco.text;
  //               setState(() {
  //                 debugPrint('컨트롤러 받는지 확인:::${_inputco} ');
  //                 debugPrint('값사용시에 _controller.text로 해줘야함 => ${inputText} ');
  //               });
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
