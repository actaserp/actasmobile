import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/e411list_model2.dart';
import '../../../model/app02/eactpernm_model.dart';
import '../../../model/app02/eremonm_model.dart';
import '../../../model/popup/egreginm_model.dart';
import '../../../model/popup/ereginm_model.dart';
import '../../../model/popup/eresultnm_model.dart';
import '../../../model/popup/eresunm_model.dart';
import '../../reusable/reusable_widget.dart';
import '../app03/Nav_right.dart';
import 'appPager17.dart';

class AppPager17Detail extends StatefulWidget {
  final e411list_model2 e411Data;
  const AppPager17Detail({Key? key, required this.e411Data}) : super(key: key);


  @override
  _AppPager17DetailState createState() => _AppPager17DetailState();
}

class _AppPager17DetailState extends State<AppPager17Detail> {

  final _reusableWidget = ReusableWidget();

  final List<String> _eGregiData = [];
  final List<String> _eRegiData = [];
  final List<String> _eResuData = [];
  final List<String> _eRemoData = [];
  final List<String> _eResultData = [];
  final List<String> _eActperidData = [];


  bool chk = true;

  late String _hour, _minute, _time;
  late String _hour2, _minute2, _time2, _dbnm;
  String? _etGregicdTxt, _etRegicdTxt, _etResucdTxt ,_etResultcdTxt, _eCompdate, _eComptime, _etRemocdTxt, _etPeridTxt;


      TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
      DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  TextEditingController _etActnm = TextEditingController();
  TextEditingController _etCompdate = TextEditingController();
  TextEditingController _etResuremark = TextEditingController();
  TextEditingController _etComptime = TextEditingController();
  TextEditingController _etArrivtime = TextEditingController();
  TextEditingController _etremoremark = TextEditingController();
  TextEditingController _etResunm = TextEditingController();

  TextEditingController _etTest = TextEditingController();
  TextEditingController _etTest2 = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      pop_eresunm();

      pop_egreginm();
      pop_ereginm();
      pop_eremonm();
    setData();
    pop_epernm();
    pop_eresultnm();


      }

  @override
  void setData() {
        _etActnm = TextEditingController(text: widget.e411Data.actnm);
        _etCompdate = TextEditingController(text: widget.e411Data.compdate);
        _etResucdTxt = widget.e411Data.resunm + " [" + widget.e411Data.resucd + "]";
        _etResuremark = TextEditingController(text: widget.e411Data.resuremark);
        _etPeridTxt = widget.e411Data.pernm + " [" + widget.e411Data.perid + "]";
        _etResultcdTxt = widget.e411Data.resultnm + " [" + widget.e411Data.resultcd + "]";
        _etremoremark = TextEditingController(text: widget.e411Data.remoremark);

        _etTest = TextEditingController(text: widget.e411Data.comptime);
        _etTest2 = TextEditingController(text: widget.e411Data.arrivtime);


  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  Future<bool> delete_data() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/apppgymobile/delete_e411';
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
        'compdate'    :  widget.e411Data.compdate,
        'compnum'       :  widget.e411Data.compnum,
        'recedate'      :  widget.e411Data.recedate,
        'recenum'     :   widget.e411Data.recenum

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


  @override
  Future<bool> update_plandata()async {
    String _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/apppgymobile/e411_update';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");
    if(_etResultcdTxt == null || _etResultcdTxt == "" ){
      showAlertDialog(context, "처리결과를 기입하세요");
      chk = false;
      return false;
    }
    if(_etGregicdTxt == null || _etGregicdTxt == "" ){
      showAlertDialog(context, "고장부위를 확인 하십시오.");
      chk = false;
      return false;
    }
    if(_etRegicdTxt == null  || _etRegicdTxt == ""){
      showAlertDialog(context, "고장부위상세를 하십시오");
      chk = false;
      return false;
    }
    if(_etResucdTxt == null  || _etResucdTxt == ""){
      showAlertDialog(context, "처리내용을 확인 하십시오.");
      chk = false;
      return false;
    }
    if( _etRemocdTxt == null  || _etRemocdTxt == ""){
      showAlertDialog(context, "고장요인을 확인 하십시오.");
      chk = false;
      return false;
    }
    if(_etPeridTxt == null || _etPeridTxt == "" ){
      showAlertDialog(context, "담당자 선택을 하십시오.");
      chk = false;
      return false;
    }

    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'resultcd':  _etResultcdTxt.toString(),
        'gregicd' : _etGregicdTxt.toString(),
        'regicd' : _etRegicdTxt.toString(),
        'resucd'  : _etResucdTxt.toString(),
        'resuremark'   : _etResuremark.text,
        'remocd' : _etRemocdTxt.toString(),
        'perid'  : _etPeridTxt.toString(),
        'remoremark'     : _etremoremark.text.toString(),
        'compnum'        : widget.e411Data.compnum,
        'compdate' :       widget.e411Data.compdate,
        'recenum'  :       widget.e411Data.recenum,


      },
    );
    if(response.statusCode == 200){
      print("수정됨");
      chk = true;
      return   true;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('고장부위 불러오는데 실패했습니다');
      return   false;
    }
  }





  @override
  Future pop_epernm()async {
    try{
      _dbnm = await  SessionManager().get("dbnm");
      var uritxt = CLOUD_URL + '/appmobile/wpernm';
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
          'wpernm': '%',
        },
      );
      if(response.statusCode == 200){
        List<dynamic> alllist = [];
        alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
        ePernmData.clear();
        _eActperidData.clear();
        for (int i = 0; i < alllist.length; i++) {
          if (alllist[i]['wperid'] != null || alllist[i]['wperid'].length > 0 ){
            eactpernm_model emObject= eactpernm_model(
                wperid:alllist[i]['wperid'],
                wpernm:alllist[i]['wpernm']
            );
            setState(() {
              ePernmData.add(emObject);
              _eActperidData.add(alllist[i]['wpernm'] + ' [' + alllist[i]['wperid'] + ']' );
              // _etResucdTxt = alllist[0]['resunm'] + ' [' + alllist[0]['resucd'] + ']'  ;
            });
          }
        }
        // print(_eResuData.length);
        return ePernmData;
      }else{
        //만약 응답이 ok가 아니면 에러를 던집니다.
        throw Exception('처리내용 불러오는데 실패했습니다');
      }
    }catch(e){
      print('e : $e');
    }

  }

  @override
  Future pop_eremonm()async {
    try{
      _dbnm = await  SessionManager().get("dbnm");
      var uritxt = CLOUD_URL + '/appmobile/wremonm';
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
          'remonm': '%',
        },
      );
      if(response.statusCode == 200){
        List<dynamic> alllist = [];
        alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
        eRemoData.clear();
        _eRemoData.clear();
        for (int i = 0; i < alllist.length; i++) {
          if (alllist[i]['remocd'] != null || alllist[i]['remocd'].length > 0 ){
            eremonm_model emObject= eremonm_model(
                remocd:alllist[i]['remocd'],
                remonm:alllist[i]['remonm']
            );
            setState(() {
              eRemoData.add(emObject);
              _eRemoData.add(alllist[i]['remonm'] + ' [' + alllist[i]['remocd'] + ']' );
              // _etResucdTxt = alllist[0]['resunm'] + ' [' + alllist[0]['resucd'] + ']'  ;
            });
          }
        }
        // print(_eResuData.length);
        return eRemoData;
      }else{
        //만약 응답이 ok가 아니면 에러를 던집니다.
        throw Exception('처리내용 불러오는데 실패했습니다');
      }
    }catch(e){
      print('e : $e');
    }

  }

  @override
  Future pop_eresultnm()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/wresultnm';
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
        'resultnm': '%',
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      eResultData.clear();
      _eResultData.clear();
      for (int i = 0; i < alllist.length; i++) {
        if (alllist[i]['resultcd'] != null || alllist[i]['resultcd'].length > 0 ){
          eresultnm_model emObject= eresultnm_model(
              resultcd:alllist[i]['resultcd'],
              resultnm:alllist[i]['resultnm']
          );
          setState(() {
            eResultData.add(emObject);
            _eResultData.add(alllist[i]['resultnm'] + ' [' + alllist[i]['resultcd'] + ']' );
            // _etResultcdTxt = alllist[0]['resultnm'] + ' [' + alllist[0]['resultcd'] + ']'  ;
          });
        }
      }
      return eResultData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('처리결과 불러오는데 실패했습니다');
    }
  }



  @override
  Future pop_egreginm()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/wgreginm';
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
        'greginm': '%',
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      eGregiData.clear();
      _eGregiData.clear();
      for (int i = 0; i < alllist.length; i++) {
        if (alllist[i]['gregicd'] != null || alllist[i]['gregicd'].length > 0 ){
          egreginm_model emObject= egreginm_model(
              gregicd:alllist[i]['gregicd'],
              greginm:alllist[i]['greginm']
          );
          setState(() {
            eGregiData.add(emObject);
            _eGregiData.add(alllist[i]['greginm'] + '[' + alllist[i]['gregicd'] + ']' );
            // _etGregicdTxt = alllist[0]['greginm'] + ' [' + alllist[0]['gregicd'] + ']'  ;
          });
        }
      }
      // _eGregiData.map((value) {
      //   print(value);
      // });
      return eGregiData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('고장부위 불러오는데 실패했습니다');
    }
  }

  @override
  Future pop_ereginm()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/wreginm';
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
        'gregicd': _etGregicdTxt.toString(),
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      eRegiData.clear();
      _eRegiData.clear();
      for (int i = 0; i < alllist.length; i++) {
        if (alllist[i]['regicd'] != null || alllist[i]['regicd'].length > 0 ){
          ereginm_model emObject= ereginm_model(
              regicd:alllist[i]['regicd'],
              reginm:alllist[i]['reginm']
          );
          setState(() {
            eRegiData.add(emObject);
            _eRegiData.add(alllist[i]['reginm'] + ' [' + alllist[i]['regicd'] + ']' );
            _etRegicdTxt = alllist[0]['reginm'] + ' [' + alllist[0]['regicd'] + ']'  ;
          });
        }
      }
      return eRegiData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('고장부위상세내용 불러오는데 실패했습니다');
    }
  }


  @override
  Future pop_eresunm()async {
    try{
      _dbnm = await  SessionManager().get("dbnm");
      var uritxt = CLOUD_URL + '/appmobile/wresunm';
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
          'resunm': '%',
        },
      );
      if(response.statusCode == 200){
        List<dynamic> alllist = [];
        alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
        eResuData.clear();
        _eResuData.clear();
        for (int i = 0; i < alllist.length; i++) {
          if (alllist[i]['resucd'] != null || alllist[i]['resucd'].length > 0 ){
            eresunm_model emObject= eresunm_model(
                resucd:alllist[i]['resucd'],
                resunm:alllist[i]['resunm']
            );
            setState(() {
              eResuData.add(emObject);
              _eResuData.add(alllist[i]['resunm'] + ' [' + alllist[i]['resucd'] + ']' );
              // _etResucdTxt = alllist[0]['resunm'] + ' [' + alllist[0]['resucd'] + ']'  ;
            });
          }
        }
        // print(_eResuData.length);
        return eResuData;
      }else{
        //만약 응답이 ok가 아니면 에러를 던집니다.
        throw Exception('처리내용 불러오는데 실패했습니다');
      }
    }catch(e){
      print('e : $e');
    }

  }


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
          '처 리 수 정',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        bottom: _reusableWidget.bottomAppBar(),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: _etActnm,
            readOnly: true,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '보수현장 *',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etCompdate,
            readOnly: true,
            onTap: () {
              /*_selectDateWithMinMaxDate(context);*/
            },
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '처리일자 *',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etTest,
            readOnly: true,
            onTap: () {
              /*_selectDateWithMinMaxDate(context);*/
            },
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '처리시간 *',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etTest2,
            readOnly: true,
            onTap: () {
              /*_selectDateWithMinMaxDate(context);*/
            },
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '도착시간 *',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('처리내용(*)'),
          ),


          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child:
            Card(
              color: Colors.blue[800],
              elevation: 5,
              child:
              Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.keyboard_arrow_down),
                    dropdownColor: Colors.blue[800],
                    iconEnabledColor: Colors.white,
                    hint: Text("처리내용", style: TextStyle(color: Colors.white)),
                    value:  this._etResucdTxt != null? this._etResucdTxt :null ,
                    items: _eResuData.map((item) {
                      return DropdownMenuItem<String>(
                        child: Text(item, style: TextStyle(color: Colors.white)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        this._etResucdTxt = value;
                        /*widget.e401receData.contcd = value;*/

                      });

                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('처리결과(*)'),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child:
            Card(
              color: Colors.blue[800],
              elevation: 5,
              child:
              Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.keyboard_arrow_down),
                    dropdownColor: Colors.blue[800],
                    iconEnabledColor: Colors.white,
                    hint: Text("처리결과", style: TextStyle(color: Colors.white)),
                    value: this._etResultcdTxt ,
                    items: _eResultData.map((item) {
                      return DropdownMenuItem<String>(
                        child: Text(item, style: TextStyle(color: Colors.white)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        this._etResultcdTxt = value;
                        widget.e411Data.resultcd = value;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etResuremark,
            readOnly: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '처리내용상세',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
            onChanged: (text){
              widget.e411Data.resuremark = text;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etremoremark,
            readOnly: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '고장원인상세',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
            onChanged: (text){
              /* _etremoremark.text = text;   */                                   /**************************************************************************************/
            },
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('고장부위  ' + '(기존: ' + widget.e411Data.greginm + widget.e411Data.gregicd + ' )'),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child:
            Card(
              color: Colors.blue[800],
              elevation: 5,
              child:
              Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.keyboard_arrow_down),
                    dropdownColor: Colors.blue[800],
                    iconEnabledColor: Colors.white,
                    hint: Text("고장부위", style: TextStyle(color: Colors.white)),
                    value: this._etGregicdTxt ,
                    items: _eGregiData.map((item) {
                      return DropdownMenuItem<String>(
                        child: Text(item, style: TextStyle(color: Colors.white)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        this._etGregicdTxt = value;
                        widget.e411Data.gregicd = value;
                      });
                      eRegiData.clear();
                      _eRegiData.clear();
                      pop_ereginm();

                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('고장부위상세  ' + '(기존: ' + widget.e411Data.reginm + ' ' + widget.e411Data.regicd + ' )'),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child:
            Card(
              color: Colors.blue[800],
              elevation: 5,
              child:
              Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.keyboard_arrow_down),
                    dropdownColor: Colors.blue[800],
                    iconEnabledColor: Colors.white,
                    hint: Text("고장부위상세", style: TextStyle(color: Colors.white)),
                    value: this._etRegicdTxt != null? this._etRegicdTxt :null ,
                    items: _eRegiData.map((item) {
                      return DropdownMenuItem<String>(
                        child: Text(item, style: TextStyle(color: Colors.white)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        this._etRegicdTxt = value;
                        widget.e411Data.regicd = value;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('고장요인 ' + '(기존: ' + widget.e411Data.remonm + ' ' + widget.e411Data.remocd + ' )'),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child:
            Card(
              color: Colors.blue[800],
              elevation: 5,
              child:
              Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.keyboard_arrow_down),
                    dropdownColor: Colors.blue[800],
                    iconEnabledColor: Colors.white,
                    hint: Text("고장요인", style: TextStyle(color: Colors.white)),
                    value: this._etRemocdTxt != null? this._etRemocdTxt :null ,
                    items: _eRemoData.map((item) {
                      return DropdownMenuItem<String>(
                        child: Text(item, style: TextStyle(color: Colors.white)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (String? value) {

                      setState(() {

                        this._etRemocdTxt = value;
                        /*widget.e401Data.remocd = value;*/   /*****************************************************************************************************************/
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('처리자, 담당자(*)'),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child:
            Card(
              color: Colors.blue[800],
              elevation: 5,
              child:
              Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.keyboard_arrow_down),
                    dropdownColor: Colors.blue[800],
                    iconEnabledColor: Colors.white,
                    hint: Text("담당자, 처리자", style: TextStyle(color: Colors.white)),
                    value: this._etPeridTxt != null? this._etPeridTxt :null ,
                    items: _eActperidData.map((item) {
                      return DropdownMenuItem<String>(
                        child: Text(item, style: TextStyle(color: Colors.white)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        this._etPeridTxt = value;
                        /*widget.e401Data.remocd = value;*/   /*****************************************************************************************************************/
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                width:  0.38 * MediaQuery.of(context).size.width,
                child: ElevatedButton(onPressed: (){
                  /*Navigator.pop(context);*/
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      content: Text('수정하시겠습니까?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () async {
                            try{
                              Navigator.pop(context);
                              await update_plandata();


                              if(chk == true) {
                                Get.off(AppPager17());
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    content: Text('수정되었습니다.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          /* Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => AppPager13()),
                            );
                            Get.off(AppPager14());*/
                                        },
                                      ),

                                    ],
                                  );
                                });
                              } else if(chk==false){
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    content: Text('입력값이 잘못되었습니다. 빈 값이 있으면 안됩니다.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context);

                                        },
                                      ),

                                    ],
                                  );
                                });
                              }
                              /* update_data();
                            *//* Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => AppPager13()),
                            );*//*
                            Get.off(AppPager13());*/
                            }
                            catch (e) {
                              print('Error occurred: $e');
                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  content: Text('에러가 발생하였습니다. 입력값이 잘못되었는지 확인바랍니다.'),
                                  actions: <Widget>[
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: Text('OK'))
                                  ],
                                );
                              });
                            }
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
                      content: Text('삭제하시겠습니까? 삭제하면 고장처리에서 삭제되며 접수목록에 다시 추가됩니다.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {

                            delete_data();
                            Get.off(AppPager17());

                          },
                        ),
                        TextButton(onPressed: (){
                          Navigator.pop(context, "취소");
                        }, child: Text('Cancel')),
                      ],
                    );
                  });
                }, child: Text('처리취소'),
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




  Future<Null> _selectDateWithMinMaxDate(BuildContext context) async {
    var firstDate = DateTime(initialDate.year, initialDate.month - 3, initialDate.day);
    var lastDate = DateTime(initialDate.year, initialDate.month, initialDate.day + 7);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.pinkAccent,
            colorScheme: ColorScheme.light(primary: Colors.pinkAccent, secondary: Colors.pinkAccent),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;

       /* widget.e401Data.compdate  = picked.toLocal().toString().split(' ')[0];*/
        _eCompdate = _selectedDate.toLocal().toString().split(' ')[0];
        _etCompdate = TextEditingController(
            text: _selectedDate.toLocal().toString().split(' ')[0]);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _etComptime.text = _time;
        widget.e411Data.comptime  = _hour  + _minute;
        _eComptime =  _hour  + _minute;
        _etComptime.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        widget.e411Data.comptime = _etComptime.text.toString();
      });
  }


  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('점검계획수정'),
          content: Text(as_msg),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "확인");
              },
            ),
          ],
        );
      },
    );
  }
}