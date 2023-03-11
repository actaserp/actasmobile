import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:actasm/model/app02/mfixlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/AttachListMB_model.dart';
import '../../reusable/cache_image_network.dart';
import '../../reusable/reusable_widget.dart';
import '../app03/Nav_right.dart';
import 'appPager13.dart';



class AppPager13Detail extends StatefulWidget {
  final mfixlist_model mfixData;
  const AppPager13Detail({Key? key, required this.mfixData}) : super(key: key);

  // final MhmanualList_model mhData;
  // const AppPage03Detail({Key? key, required this.mhData}) : super(key: key);

  @override
  _AppPager13DetailState createState() => _AppPager13DetailState();

}

class _AppPager13DetailState extends State<AppPager13Detail> {

  TextEditingController _etfnsubject     = TextEditingController();
  TextEditingController _etfmemo         = TextEditingController();
  List<String> dropdownList = ['합격', '불합격', '조건부'];
  String _selectedValue = "";
  String ? _selectedValue2;
  String _shared = "N";

  late String _dbnm;
  late String _attachidx;
  final List<String> _ATCData = [];
  final List<String> _idxData = [];
  final List<String> _seqData = [];








  @override
  void setData(){

    _attachidx = widget.mfixData.fseq;
    _etfnsubject = TextEditingController(text: widget.mfixData.fnsubject);
    _etfmemo     = TextEditingController(text: widget.mfixData.fmemo);


  }


  @override
  Future comment()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/apppgymobile/attachMB';
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
        'fflag':  "MF",
        'fseq' : widget.mfixData.fseq.toString(),
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      ATCData_MB.clear();
      _ATCData.clear();
      idxData_MB.clear();
      _idxData.clear();
      seqData_MB.clear();
      _seqData.clear();

      for (int i = 0; i < alllist.length; i++) {
        AttachListMB_model AttObject= AttachListMB_model(
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
          ATCData_MB.add(AttObject);
          _ATCData.add(alllist[i]['originalName']);
          idxData_MB.add(AttObject);
          _idxData.add(alllist[i]['idx'].toString());
          seqData_MB.add(AttObject);
          _seqData.add(alllist[i]['boardIdx']);
        });
      }
      debugPrint('Attatch data $ATCData_MB length:${ATCData_MB.length}' );
      print(widget.mfixData.fflag);
      print(widget.mfixData.fseq);
      return
        ATCData_MB;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }




  @override
  void initState() {

    comment();
    setData();
    // TODO: implement initState
    super.initState();


    if(widget.mfixData.fflag == "Y"){
      _goodParts.add("Y");
    }
    /*print("$CLOUD_URL" + "/appx2/download?actidxz=${_idxData[index]}&actboardz=${_seqData[index]}&actflagz=MF");*/
    print("${_idxData}");
    print("${_seqData}");
    print('object');

  }

  @override
  void dispose() {
    // TODO: implement dispose
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  Future<bool> update_data() async {
    String _dbnm = await SessionManager().get("dbnm");

    if(_selectedValue == "" || _selectedValue == null || _selectedValue == ''){
      _selectedValue = widget.mfixData.fgourpcd;
    }

    var uritxt = CLOUD_URL + '/apppgymobile/update';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    // try {
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
      },
      body: <String, String>{
        'fseq'    :  widget.mfixData.fseq,
        'fnsubject': _etfnsubject.text,
        'fmemo'    : _etfmemo.text,
        'fgourpcd' : _selectedValue,
        'fflag'    : _shared,

      },
    );
    if (response.statusCode == 200) {
      print('저장됨');
      return true;

    } else {
      // Fluttertoast.showToast(msg: e.toString());
      throw Exception('불러오는데 실패했습니다');
      return false;
    }
    // } catch (e) {
    //   //만약 응답이 ok가 아니면 에러를 던집니다.
    //   Fluttertoast.showToast(msg: '에러입니다.');
    //   return <MhmanualList_model>[];
    // }
  }


  Future<bool> delete_data() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/apppgymobile/delete';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    // try {
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
      },
      body: <String, String>{
        'dbnm'    : _dbnm,
        'fseq'    :  widget.mfixData.fseq,

      },
    );
    if (response.statusCode == 200) {
      print('삭제됨');
      return true;

    } else {
      // Fluttertoast.showToast(msg: e.toString());
      throw Exception('불러오는데 실패했습니다');
      return false;
    }
    // } catch (e) {
    //   //만약 응답이 ok가 아니면 에러를 던집니다.
    //   Fluttertoast.showToast(msg: '에러입니다.');
    //   return <MhmanualList_model>[];
    // }
  }





  final List<String> _C750Data = [];
  final _reusableWidget = ReusableWidget();
  List<String> _goodParts = [];
  int _maxgoodParts = 2;


  @override
  Widget build(BuildContext context){
    return Scaffold(
      endDrawer: Nav_right(text: Text('app03_nav'),
        color: SOFT_BLUE,),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text(
          '점검조치사항',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
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
                Text(
                    'No.${widget.mfixData.fseq}', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: CHARCOAL
                )
                ),
                Spacer(),
                Text(
                  '등록일자: ${widget.mfixData.finputdate}', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: CHARCOAL
                ),

                )
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
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child:
                    TextField(
                      controller: _etfnsubject,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                          labelText: '제목 :',
                          labelStyle:
                          TextStyle(color: Colors.black)
                      ),
                    )
                  /*Text('제목: ${widget.mfixData.fnsubject}', style: TextStyle(
                      fontSize:16, fontWeight: FontWeight.bold, color: SOFT_BLUE
                  )),*/
                ),
                SizedBox(
                  height: 30,
                ),
                Card(
                  color: SOFT_BLUE,
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        icon: Icon(Icons.keyboard_arrow_down),
                        dropdownColor: SOFT_BLUE,
                        iconEnabledColor: Colors.white,
                       /* value: "aa",*/
                        hint: Text(widget.mfixData.cnam,  style: TextStyle(color: Colors.white)),
                        items: dropdownList.map((item) {
                          return DropdownMenuItem<String>(
                            child: Text(item, style: TextStyle(color: Colors.white)),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (String? value) =>
                          setState(() {
                            if(value.toString() == "합격"){
                              _selectedValue = "001";
                            }

                            if(value.toString() == "불합격"){
                              _selectedValue = "002";
                            }

                            if(value.toString() == "조건부"){
                              _selectedValue = "003";
                            }
                            this._selectedValue2 = value;

                          }),
                          value: _selectedValue2,

                          /*C751Data.clear();
                    _C751Data.clear();
                    pop_Com751();*/

                      ),
                    ),
                  ),

                ),
                /*Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text('작성자 <${widget.mfixData.fpernm}> , 구분 [${widget.mfixData.fgourpcd}]', style: TextStyle(
                          fontSize: 11, color: CHARCOAL
                      ))
                    ],
                  ),
                ),*/
                /*Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _checboxgood(value: 'Y', primaryText: '회원사 공유 여부'),
                        ],
                      ),
                    )
                  ],
                ),*/

                Container(
                    margin: EdgeInsets.only(top: 8),
                    child:

                    TextField(
                      controller: _etfmemo,
                      maxLines: 4,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                          labelText: '내용 :',
                          labelStyle:
                          TextStyle(color: Colors.black)
                      ),
                    )
                  /*Text('내용: ${widget.mfixData.fmemo}', style: TextStyle(
                      fontSize: 14, color: CHARCOAL
                  )),*/
                ),

                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Text('첨부파일리스트', style: TextStyle(
                          fontSize:13, fontWeight: FontWeight.bold, color: CHARCOAL
                      )),
                      SizedBox(
                        width: 150,
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
          Row(
            children: [
              Container(
                width:  0.38 * MediaQuery.of(context).size.width,
                child: ElevatedButton(onPressed: (){
                  /*Navigator.pop(context);*/
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      content: Text('수정하시겠습니까?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            update_data();
                           /* Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => AppPager13()),
                            );*/
                            Get.off(AppPager13());
                          },
                        ),
                        TextButton(onPressed: (){
                          Navigator.pop(context, "취소");
                        }, child: Text('Cancel')),
                      ],
                    );
                  });
                }, child: Text('수정하기')),
              ),


              Container(
                width: 0.38 * MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20),
                child: ElevatedButton(onPressed: (){
                  /*Navigator.pop(context);*/
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      content: Text('삭제하시겠습니까?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            delete_data();
                            /* Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => AppPager13()),
                            );*/
                            Get.off(AppPager13());
                          },
                        ),
                        TextButton(onPressed: (){
                          Navigator.pop(context, "취소");
                        }, child: Text('Cancel')),
                      ],
                    );
                  });
                }, child: Text('삭제하기'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    //onPrimary: Colors.black,
                  ),),
              ),

            ],
          )
        ],
      ),
    );
  }

  //체크박스
  Widget _checboxgood({value = 'Y' , primaryText: '회원사 공유 여부'}){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        setState(() { //tap 시에 value 다시 잡아주고
          if(_goodParts.contains(value)){
            _goodParts.remove(value);
            _shared = "N";
          } else {
            if(_goodParts.length<_maxgoodParts){
              _goodParts.add(value);
              _shared = "Y";
            }
          }
            print(_shared);
        });
      },
      child: Row(
        children: [
          Text(primaryText, style: TextStyle(
              fontSize: 15,
              color: SOFT_BLUE,
              fontWeight: (_goodParts.contains(value))?FontWeight.bold:FontWeight.normal
          )),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: (_goodParts.contains(value)) ? PRIMARY_COLOR : BLACK77
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(4.0)
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: (_goodParts.contains(value))
                  ? Icon(
                Icons.check,
                size: 12.0,
                color: PRIMARY_COLOR,
              ):Icon(
                Icons.check_box_outline_blank,
                size: 12.0,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 16),
          // Spacer(),
          // Text(secondaryText, style: TextStyle( //수량나타내주는거
          //   fontSize: 13,
          //   color: BLACK77,
          // ))
        ],
      ),
    );
  }



  Widget _buildFileList() {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: ListView.builder(shrinkWrap: true,
              itemCount: _ATCData.length,
              itemBuilder: (BuildContext context, int index)
              {
                return
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 105, ),
                            child:  Column(
                              children: [
                                ClipRRect(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    child: buildCacheNetworkImage(width: 320, height: 200, url: "$CLOUD_URL" + "/appx2/download2?actidxz=${_idxData[index]}&actboardz=${_seqData[index]}&actflagz=MF")
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
                    );
              }),
        ),
      ),
    );
  }

}