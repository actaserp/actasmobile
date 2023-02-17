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



import '../../../model/app03/AttachList_model.dart';
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

  late String _dbnm, _attatchidx;
  final List<String> _ATCData = [];

  @override
  void setData() {
    _attatchidx = widget.MhData.hseq;
  }

  @override
  Future comment()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/downlist';
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
        'flag':  widget.MhData.hseq.toString(),
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      ATCData.clear();
      _ATCData.clear();
      for (int i = 0; i < alllist.length; i++) {
        AttachList_model AttObject= AttachList_model(
          idx:alllist[i]['idx'],
          boardIdx:alllist[i]['boardIdx'],
          originalName:alllist[i]['originalName'],
          saveName:alllist[i]['saveName'],
          size:alllist[i]['size'],
          flag:alllist[i]['flag'],
          deleteyn:alllist[i]['deleteyn'],
          inserttime:alllist[i]['inserttime'],
          deletetime:alllist[i]['inserttime'],

        );
        setState(() {
          ATCData.add(AttObject);
          _ATCData.add(alllist[i]['idx'] + '[' + alllist[i]['boardIdx'] + ']' + alllist[i]['originalName'] + ']'  + alllist[i]['saveName'] + ']' + alllist[i]['size'] + ']' + alllist[i]['flag'] + ']');

        });
      }
      _ATCData.map((value) {
        print(value);
      });
      return
        ATCData;

    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }

  @override
  void initState() {
    comment();
    debugPrint('The value of a is $ATCData');
    setData();
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
          '수리노하우',
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
          Text('Date.${widget.MhData.hinputdate}', style: TextStyle(
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
                  child: Text('제목: ${widget.MhData.hsubject}', style: TextStyle(
                      fontSize:16, fontWeight: FontWeight.bold, color: SOFT_BLUE
                  )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text('작성자 <${widget.MhData.hpernm}> , 구분 [${widget.MhData.hgroupcd}]', style: TextStyle(
                          fontSize: 11, color: CHARCOAL
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
                  child: Text('내용: ${widget.MhData.hmemo}', style: TextStyle(
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
          ),
              ],
            ),
          );

  }


//첨부파일리스트
Widget _buildFileList() {
  return Container(
    margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
         child:
         // ListView.builder(
         //   itemCount: MhData.length,
         //   itemBuilder:(BuildContext context, int index)
         //  {
         //    return
                 Column(
                   ///왼쪽배열
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                        Text('첨부파일 목록', style: TextStyle(
                            fontSize: 20,
                            color: SOFT_BLUE,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                        Text('첨부파일 목록', style: TextStyle(
                            fontSize: 20,
                            color: SOFT_BLUE,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                        Text('첨부파일 목록', style: TextStyle(
                            fontSize: 20,
                            color: SOFT_BLUE,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                      ],
                    ),


  );
}


}