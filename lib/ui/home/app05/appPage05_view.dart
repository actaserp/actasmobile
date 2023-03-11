import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app05/SCmanualList_model.dart';
import 'package:actasm/model/app05/SmanualList_model.dart';
import 'package:actasm/ui/account/tab_account.dart';
import 'package:actasm/ui/home/app03/Nav_right.dart';
import 'package:actasm/ui/home/app05/appPage05.dart';
import 'package:actasm/ui/home/tab_home.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../model/app03/AttachList_model.dart';
import '../../../model/app04/BmanualList_model.dart';
import '../../reusable/cache_image_network.dart';

class AppPage05view extends StatefulWidget {
  final SmanualList_model SData;
  const AppPage05view({Key? key, required this.SData}) : super(key: key);

  @override
  _AppPage05ViewState createState() => _AppPage05ViewState();
}

class _AppPage05ViewState extends State<AppPage05view> {
  final _reusableWidget = ReusableWidget();
  late String _dbnm, _attatchidx;
  TextEditingController _memo = TextEditingController();
  var _usernm = "";
  var nullableBool = "";
  @override
  Future<void> sessionData() async {
    String username = await  SessionManager().get("username");
    _usernm = utf8.decode(username.runes.toList());
    setState(() {
      _usernm;
    });
  }

  @override
  void initState() {
    sessionData();
    super.initState();

  }


  @override
  void dispose() {
    super.dispose();
  }

  //저장
  @override
  Future<bool> save_scdata()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/saveeSS2';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("@@@@@@@@@@@댓글 저장@@@@@@@@@@@@@@@@");
    print(_usernm);
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
        'spernm': _usernm.toString(),
        'smemo': _memo.text.toString(),
        'sseq' : nullableBool,
        'subkey':  widget.SData.sseq,
      },
    );
    if(response.statusCode == 200){
      print("저장됨");
      return   true;
    }else{
      throw Exception('댓글 저장에 실패했습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double boxChatSize = MediaQuery.of(context).size.width/1.3;
    int _selectedIndex = 0;
    return Scaffold(
      endDrawer: Nav_right(
        text: Text('qna'),
        color: SOFT_BLUE,
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.question_answer),
            Text(
              ' 수리 Q&A',
              style: GlobalStyle.appBarTitle,
            ),
          ],
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,

      ),
      body:ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(12),
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(7)
                  ),
                  child: Container(
                    color: SOFT_BLUE,
                    child: Text('  질문 상세  ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white
                        )),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0xffcccccc),
                            width: 1.0,
                          ),
                        ),
                      ),
                      width: 750,
                      child: _buildHEAD()
                  ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 650,
                child: ListView.builder(
                    padding: EdgeInsets.only( bottom: 10),
                    itemCount: SCData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final SCmanualList_model SCmemo = SCData[index];
                      final sseqlist = widget.SData.sseq;
                      final subkeylist = SCmemo.subkey;
                      if (subkeylist == sseqlist) {
                        return _buildchat(SCData[index]);
                      } else {
                        return SizedBox.shrink();
                      }
                    }

                ),
              ),
              Cmemo(),
            ],
          ),


        ],
        ///listview 하단에도 padding 값이 필요하다. 혹은 margin으로 조절
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
            icon: Icon(Icons.question_answer),
            label: 'Q&A',
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

  ///헤더 제작
  Widget _buildHEAD(){
    final double WidthSize = (MediaQuery.of(context).size.width*1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Container(
          width: WidthSize,
          margin: EdgeInsets.only(top:15, bottom: 15),
          /// 질문 제목
          child: Row(
            children: [
              Center(
                child: Text('No.${widget.SData.sseq.toString().substring(7,9)} :: ', style: TextStyle(
                    color: SOFT_GREY, fontSize: 12
                )),
              ),
              Center(
                child: Text('${widget.SData.sinputdate}', style: TextStyle(
                    color: SOFT_GREY, fontSize: 12
                )),
              ),
              Center(
                child: Text('  ${widget.SData.spernm}', style: TextStyle(
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
        ///질문 내용
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
                    padding:EdgeInsets.all(16),
                    child: Text('${widget.SData.smemo}', style: TextStyle(
                        fontSize:14, fontWeight: FontWeight.bold, color: SOFT_BLUE
                    )),
                  ),
                ],
              ),
            ],
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
  ///본문 입력 위젯 no data
  Widget Cmemo(){
    return   Container(
        child: Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: _memo,
                  minLines: 1,
                  maxLines: 3,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: Colors.grey[500],
                    filled: true,
                    hintText: '댓글을 입력해 주세요',
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
                    String inputText2 = _memo.text;
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
                              await  save_scdata();
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
}