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
import 'package:actasm/ui/home/app05/appPage05.dart';
import 'package:actasm/ui/home/tab_home.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
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
  final List<String> _ATCData = [];
  final List<String> _idxData = [];
  final List<String> _seqData = [];
  String? _thumfile;
  Uint8List? _thumdata;
  ///여기서부터 blank
  TextEditingController _memo = TextEditingController();
  TextEditingController _subject = TextEditingController();
  TextEditingController _etCompdate = TextEditingController();

  @override
  void setData() {
    _attatchidx = widget.SData.sseq;
  }


  @override
  void initState() {
    setData();
    super.initState();

  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double boxChatSize = MediaQuery.of(context).size.width/1.3;
    int _selectedIndex = 0;
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
        // bottom: _reusableWidget.bottomAppBar(),
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
                  ),              child: Container(
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
            icon: Icon(Icons.refresh),
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
                  )
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
                Text('subkey 확인 ::: ${SCData.subkey}', style: TextStyle(
                    color: Colors.red, fontSize: 12
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
                  onTap: (){
                    String inputText2 = _memo.text;
                    if(inputText2 != ''){
                      print('메시지 전송 출력 확인 => '+ inputText2);
                      setState(() {
                        inputText2;
                        debugPrint('값 받는지 확인:::${inputText2} ');
                      });
                    }
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