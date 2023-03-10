import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/ui/home/app04/appPage04.dart';
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

class AppPage04view extends StatefulWidget {
  final BmanualList_model BData;
  const AppPage04view({Key? key, required this.BData}) : super(key: key);

  @override
  _AppPage04ViewState createState() => _AppPage04ViewState();
}

class _AppPage04ViewState extends State<AppPage04view> {
  final _reusableWidget = ReusableWidget();
  late String _dbnm, _attatchidx;
  final List<String> _ATCData = [];
  final List<String> _idxData = [];
  final List<String> _seqData = [];
  final List<String> _inData = [];
  final List<String> _SaNData = [];

  ///여기서부터 blank
  TextEditingController _memo = TextEditingController();
  TextEditingController _subject = TextEditingController();
  TextEditingController _etCompdate = TextEditingController();

  @override
  void setData() {
    _attatchidx = widget.BData.bseq;
  }

  Future Blist_del() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/Bdel';
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
        'bseq' : widget.BData.bseq.toString()
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
  Future<bool> re_mbdata()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/saveeMB';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("------------부품가이드 수정----------------");
    ///null처리
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'binputdate': widget.BData.binputdate.toString(),
        'bpernm': widget.BData.bpernm.toString(),
        'bmemo': _memo.text.toString(),
        'bsubject': _subject.text.toString(),
        'bgroupcd': '01'.toString(),
        'bseq':widget.BData.bseq.toString(),
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
  Future attachMB()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/attachMB';
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
        'flag':  widget.BData.bflag.toString(),
        'boardIdx' : widget.BData.bseq.toString(),
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
      debugPrint('Attatch data::: $ATCData length::::${ATCData.length}' );
      return
        ATCData;
    }else{
      throw Exception('첨부파일 리스트를 불러오는데 실패했습니다');
    }
  }

  Future downmb() async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/mobile/download?dbnm=$_dbnm&flag=${widget.BData.bflag}&boardIdx=${widget.BData.bseq}&idx=${_idxData.toString().substring(1,3)}&inputdate=${_inData.toString().substring(1,11).replaceAll('-', '')}&svn=${_SaNData.toString().substring(1).replaceAll(']', '')}&ori=${_ATCData.toString().substring(1).replaceAll(']', '')}';
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
    _subject.text = widget.BData.bsubject;
    _memo.text = widget.BData.bmemo;
    attachMB();
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
          '부품가이드',
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
              children: [
                Text('Date.${widget.BData.binputdate}', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: CHARCOAL
                )),
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
                        bool lb_save = await re_mbdata();
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
                                  await  Blist_del();
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => AppPage04()));
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
                        GestureDetector(
                          onTap: () async{
                            bool ap_down = await downmb();
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
                                  ///이미지 확대기능 ~ url을 가져오니 자꾸 바이너리로 인식하여 다운로드가 실행돼서 우선적으로 막아뒀다.
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
                    );

                }
            ),
          ),
        )


    );
  }


}