import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'package:actasm/ui/home/app03/appPage03.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app03/MhmanualList_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


import '../../../model/app03/AttachList_model.dart';
import '../../reusable/cache_image_network.dart';

class AppPage03view extends StatefulWidget {
  final MhmanualList_model MhData;
  const AppPage03view({Key? key, required this.MhData}) : super(key: key);

  @override
  _AppPage03ViewState createState() => _AppPage03ViewState();
}

class _AppPage03ViewState extends State<AppPage03view> {
  ///처리등록되었습니다 startloading
  final _reusableWidget = ReusableWidget();
  late String _dbnm, _attatchidx;
  final List<String> _ATCData = [];
  final List<String> _idxData = [];
  final List<String> _seqData = [];
  ///다운로드 통신시 필요(1)
  final List<String> _inData = [];
  final List<String> _SaNData = [];
  ///여기서부터 blank
  TextEditingController _memo = TextEditingController();
  TextEditingController _subject = TextEditingController();
  TextEditingController _etCompdate = TextEditingController();

  @override
  void setData() {
    _attatchidx = widget.MhData.hseq;
  }
  Future mhlist_del() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/mhdel';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
      },
      body: <String, String>{
        'dbnm': _dbnm,
        'hseq' : widget.MhData.hseq.toString()
      },
    );
    if (response.statusCode == 200) {
      print('삭제됨');
      return true;
    } else {
      throw Exception('불러오는데 실패했습니다');
    }

  }

  @override
  Future<bool> re_mhdata()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/saveeMh';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("------------수리노하우 수정----------------");
    ///null처리
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'hinputdate': widget.MhData.hinputdate.toString(),
        'hpernm': widget.MhData.hpernm.toString(),
        'hmemo': _memo.text.toString(),
        'hsubject': _subject.text.toString(),
        'hgroupcd': '01'.toString(),
        'hseq':widget.MhData.hseq.toString(),
      },
    );
    if(response.statusCode == 200){
      print("저장됨");
      return   true;
    }else{
      throw Exception('수리노하우 수정에 실패했습니다');
    }
  }

  @override
  Future attachMH()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/attachMH';
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
        'flag':  widget.MhData.hflag.toString(),
        'boardIdx' : widget.MhData.hseq.toString(),
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      ATCData.clear();
      _ATCData.clear();
      idxData.clear();
      _idxData.clear();
      seqData.clear();
      _seqData.clear();
      _inData.clear();
      _SaNData.clear();

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
          deletetime:alllist[i]['deletetime'],

        );
        setState(() {
          ATCData.add(AttObject);
          _ATCData.add(alllist[i]['originalName']);
          idxData.add(AttObject);
          _idxData.add(alllist[i]['idx'].toString());
          seqData.add(AttObject);
          _seqData.add(alllist[i]['boardIdx']);
          _inData.add(alllist[i]['inserttime']);
          _SaNData.add(alllist[i]['saveName']);


        });
      }
      debugPrint('Attatch data $ATCData length:${ATCData.length}' );
      return
        ATCData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }

  ///다운로드 통신시 필요(2)
  ///다운로드 get통신
  Future downmh()async {
    _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/mobile/download?dbnm=$_dbnm&flag=${widget.MhData.hflag}&boardIdx=${widget.MhData.hseq}&idx=${_idxData.toString().replaceAll('[', '').replaceAll(']', '')}&inputdate=${_inData.toString().substring(1,11).replaceAll('-', '')}&svn=${_SaNData.toString().substring(1).replaceAll(']', '')}&ori=${_ATCData.toString().substring(1).replaceAll(']', '')}';
    // &inputdate=${_inData.toString().substring(1,3)}
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);

    print('@@@@@@@@@@@@@@@데이터 테스트@@@@@@@@@@@@@@@@@@@@@');
    print('값확인::: ${_ATCData.toString().substring(1).replaceAll(']', '')}');
    final response = await http.get(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/octet-stream',
      },
    );
    if(response.statusCode == 200){
      await writeToFile(response);
      print('저장됨');
      return true;
    }else {
      // throw Exception('다운로드 통신 실패했습니다');
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      print('다운로드 통신 실패했습니다.');
      return false;

    }
  }

  Future<void> writeToFile(http.Response response) async {
    var externalStorageDirPath;
    final directory = await getExternalStorageDirectory();
    externalStorageDirPath = directory?.path;
    final folder = await getExternalStorageDirectory();
    final filename = _ATCData[0].toString();
    final path = '${externalStorageDirPath}/$filename';
    print(path);
    final file = File(path);
    await file.writeAsBytes(response.bodyBytes);
  }
  @override
  void initState() {
    _subject.text = widget.MhData.hsubject;
    _memo.text = widget.MhData.hmemo;
    attachMH();
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
       physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(26),
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Date.${widget.MhData.hinputdate}', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: CHARCOAL
                )),
                Visibility(
                  visible: false,
                  child: Text('${widget.MhData.hflag}', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700, color: CHARCOAL
                  )),
                ),
                SizedBox(
                  width: 10,
                ),
                Visibility(
                  visible: false,
                  child: Text('${widget.MhData.hseq}', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700, color: CHARCOAL
                  )),
                ),
                SizedBox(
                  width: 10,
                )
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
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: TextField(
                    controller: _subject,
                    autofocus: true,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: '제목 입력',
                        labelStyle:
                        TextStyle(fontSize:23, fontWeight: FontWeight.bold, color: SOFT_BLUE),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 2),
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
                  child: TextField(
                    controller: _memo,
                    autofocus: true,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: '내용 입력',
                      labelStyle:
                      TextStyle(fontSize:23, fontWeight: FontWeight.bold, color: CHARCOAL),
                      border: InputBorder.none,
                    ),
                  ),
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
                      child: Row(
                        children: [
                          Text('첨부파일리스트', style: TextStyle(
                              fontSize:13, fontWeight: FontWeight.bold, color: CHARCOAL
                          )),
                          SizedBox( //여기수정
                            width: MediaQuery.of(context).size.width/2.45,
                          ),
                        ],
                      ),
                    ),
                            SizedBox(
                              height: 12,
                            ),
                            ///첨부파일리스트
                            _buildFileList(),
                            SizedBox(
                              height: 20,
                            ),
              ],
            ),
          ),
          ///등록 시작
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) => SOFT_BLUE,
                        ),
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            )
                        ),
                      ),
                        onPressed: ()async  {
                          bool lb_save = await re_mhdata();
                          if (lb_save){
                          _reusableWidget.startLoading(context, '수정 되었습니다. 새로고침해주세요.', 1 );
                          }
                        },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          '수정하기',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) => Colors.red,
                        ),
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            )
                        ),
                      ),
                      onPressed: () {
                      showDialog(
                        context: context,
                      builder: (context) => AlertDialog(
                      title: Text('삭제하시겠습니까?'),
                            actions: [
                              TextButton(
                                child: Text('취소'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text('삭제'),
                                onPressed: () async {
                                  await mhlist_del();
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => AppPage03()));
                                },
                              ),
                            ],
                      ),
                      );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          '삭제하기',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                ),
              ),
            ],
          ),

              ],
            ),

          );

  }


Widget _buildFileList() {
  final double boxImageSize = (MediaQuery.of(context).size.width / 5);
  return Container(
    margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
         child:
         SingleChildScrollView(
           scrollDirection: Axis.vertical,
           child: Container(
             child: ListView.builder(
                 physics: NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
               itemCount: _ATCData.length,
               itemBuilder:(BuildContext context, int index)
              {
                return
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         ///다운로드 통신시 필요(3)
                         GestureDetector(
                         onTap: () async{
                        bool ap_down = await downmh();
                            if (ap_down){
                              showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text('파일 저장'
                                  ),
                                  titleTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                  content: Text("저장소를 확인하세요."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('확인'),
                                    ),
                                        ]
                                    );
                                  }
                              );
                            }else{
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        content: Text("서버 관리자에게 문의하세요."),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text('확인'),
                                          ),
                                        ]
                                    );
                                  }
                              );
                            }
                          },
                               child: ConstrainedBox(
                                 constraints: BoxConstraints(minWidth: 105, ),
                               child:  Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   InteractiveViewer(
                                     ///이미지 확대기능
                                     boundaryMargin: const EdgeInsets.all(20.0),
                                     minScale: 0.5,
                                     maxScale: 2.6,
                                    child: ClipRRect(
                                   borderRadius:
                                     BorderRadius.all(Radius.circular(14)),
                                     child: buildCacheNetworkImage(width: boxImageSize, height: boxImageSize, url: "")
                                     ),
                                 ),
                                   Text('${_ATCData[index]}',
                                     style: TextStyle(
                                       fontSize: 20,
                                       color: SOFT_BLUE,
                                       fontWeight: FontWeight.bold
                                   ),
                                   ),
                                 ],
                               ),
                               ),
                           ),
                          ],
                        );}
  ),
           ),
         )


  );
}

}