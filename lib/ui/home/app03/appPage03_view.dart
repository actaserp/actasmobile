import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app03/MhmanualList_model.dart';

import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:thumbnailer/thumbnailer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../model/app03/AttachList_model.dart';
import '../../reusable/cache_image_network.dart';
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
  final List<String> _idxData = [];
  final List<String> _seqData = [];



  @override
  void setData() {
    _attatchidx = widget.MhData.hseq;
  }



  @override
  Future comment()async {
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

  final ReceivePort _port = ReceivePort();

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int downloadProgress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, downloadProgress]);
  }

  @override
  void initState() {

    comment();
    setData();
    super.initState();

    ///다운로드
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
    ///썸네일
    Thumbnailer.addCustomMimeTypesToIconDataMappings(<String, IconData>{
      'custom/mimeType': FontAwesomeIcons.key,
    });
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
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
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Date.${widget.MhData.hinputdate}', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: CHARCOAL
                )),
                SizedBox(
                  width: 275,
                ),
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
                      child: Row(
                        children: [
                          Text('첨부파일리스트', style: TextStyle(
                              fontSize:13, fontWeight: FontWeight.bold, color: CHARCOAL
                          )),
                          SizedBox(
                            width: 355,
                          ),
                          Container(
                            height:35,
                            width: 70,
                            child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) => PRIMARY_COLOR,
                                  ),
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3.0),
                                      )
                                  ),
                                ),
                                onPressed: () {
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 1),
                                  child: Text(
                                    '불러오기',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                            ),
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
         SingleChildScrollView(
           scrollDirection: Axis.vertical,
           child: Container(
             child: ListView.builder(
                 shrinkWrap: true,
               itemCount: _ATCData.length,
               itemBuilder:(BuildContext context, int index)
              {
                return
                     Column(
                       ///왼쪽배열
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                           GestureDetector(
                               onTap: () async{
                                 String dir = (await getApplicationDocumentsDirectory()).path;
                                 try{
                                   await FlutterDownloader.enqueue(
                                     url: "$CLOUD_URL" + "/happx/download?actidxz=${_idxData[index]}&actboardz=${_seqData[index]}&actflagz=MH", 	// file url
                                     savedDir: '$dir',	// 저장할 dir
                                     fileName: '${_ATCData[index]}',	// 파일명
                                     showNotification: true, // show download progress in status bar (for Android)
                                     saveInPublicStorage: true ,	// 동일한 파일 있을 경우 덮어쓰기 없으면 오류발생함!
                                   );
                                   print("파일 다운로드 완료");
                                 }catch(e){
                                   print("eerror :::: $e");
                                   print("idx :::: $_idxData seq :::: $_seqData" + " url 시작 ::: $CLOUD_URL + /happx/download?actidxz=?${_idxData[index]}&actboardz=${_seqData[index]}&actflagz=MH");
                                 }
                               },
                               child: ConstrainedBox(
                                 constraints: BoxConstraints(minWidth: 105, ),
                               child:  Column(
                                 children: [
                                 ClipRRect(
                                 borderRadius:
                                   BorderRadius.all(Radius.circular(4)),
                                   child: buildCacheNetworkImage(width: 200, height: 200, url: "$CLOUD_URL" + "/happx/download?actidxz=${_idxData[index]}&actboardz=${_seqData[index]}&actflagz=MH")
                                   ),
                                   Text('${_ATCData[index]}', style: TextStyle(
                                       fontSize: 20,
                                       color: SOFT_BLUE,
                                       fontWeight: FontWeight.bold
                                   ),
                                   ),
                                 ],
                               ),
                               ),
                           ),
                         Divider(),
                          ],
                        );}
  ),
           ),
         )


  );
}


}