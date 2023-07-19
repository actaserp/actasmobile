import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
// import 'dart:js';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app04/MmanualList_model.dart';

import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../model/app03/AttachList_model.dart';
import '../../../model/app04/MmanualList_model.dart';
import '../../reusable/cache_image_network.dart';
import '../tab_home.dart';

class AppPage08view extends StatefulWidget {
  final MmanualList_model MData;
  const AppPage08view({Key? key, required this.MData}) : super(key: key);

  @override
  _AppPage08viewState createState() => _AppPage08viewState();
}

class _AppPage08viewState extends State<AppPage08view> {

  late String _dbnm, _attatchidx;
  final List<String> _ATCData = [];
  final List<String> _idxData = [];
  final List<String> _seqData = [];
  ///다운로드 통신시 필요(1)
  final List<String> _inData = [];
  final List<String> _SaNData = [];

  @override
  void setData() {
    _attatchidx = widget.MData.mseq;
  }

  @override
  Future attachfiles()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/fileThumblist';
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
        'flag':  'MM',
        'boardIdx' : widget.MData.mseq.toString(),
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

  Future downmb() async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/mobile/download?dbnm=$_dbnm&flag=MM&boardIdx=${widget.MData.mseq}&idx=${_idxData.toString().replaceAll('[', '').replaceAll(']', '')}&inputdate=${_inData.toString().substring(1,11).replaceAll('-', '')}&svn=${_SaNData.toString().substring(1).replaceAll(']', '')}&ori=${_ATCData.toString().substring(1).replaceAll(']', '')}';
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
    attachfiles();
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
          '도면자료실',
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
                  child: Text('제목 : ${widget.MData.msubject}', style: TextStyle(
                      fontSize:16, fontWeight: FontWeight.bold, color: SOFT_BLUE
                  )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text('분류 : ${widget.MData.cnam}', style: TextStyle(
                      fontSize:13, fontWeight: FontWeight.bold
                  )),
                ),
                Container(
                  child: Row(
                    children: [
                      Text('작성자 : ${widget.MData.mpernm}',style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold
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
                  child: Text('${widget.MData.mmemo}', style: TextStyle(
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
                  child: Row(
                    children: [
                      Text('첨부파일리스트 (${widget.MData.attcnt}개)', style: TextStyle(
                          fontSize:13, fontWeight: FontWeight.bold, color: CHARCOAL
                      )),
                      SizedBox(
                        width: 355,
                      ),
                    ],
                  ),
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
          SizedBox(
            height: 12,
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