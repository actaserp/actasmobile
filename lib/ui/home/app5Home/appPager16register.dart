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
import '../../../model/app02/e401recelist_model.dart';
import '../../../model/app02/e401recelist_model.dart';
import '../../../model/app02/eactpernm_model.dart';
import '../../../model/popup/econtnm_model.dart';
import '../app03/Nav_right.dart';
import 'appPager16.dart';
import 'appPager16Actnm.dart';

class AppPager16register extends StatefulWidget {


  // final MhmanualList_model mhData;
  // const AppPage03Detail({Key? key, required this.mhData}) : super(key: key);

  @override
  _AppPager16registerState createState() => _AppPager16registerState();
}
class _AppPager16registerState extends State<AppPager16register> {

  late String _hour, _minute, _time;
  String _erecetime = '';
  String _ehitchtime = '';
  String actcd = "";
  String actnm = "";
  String cltcd = "";
  String equpcd = "";
  String equpnm = "";
  String recenum = "";
  String recedate2 = "";


  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  final List<String> _eContData = [];

  String? _etContcdTxt;

  TextEditingController _etrecedate = TextEditingController();
  TextEditingController _etrecetime = TextEditingController();
  TextEditingController _ethitchdate = TextEditingController();
  TextEditingController _ethitchtime = TextEditingController();
  TextEditingController _etactnm = TextEditingController();
  TextEditingController _etequpnm = TextEditingController();
  TextEditingController _etcontnm = TextEditingController();
  TextEditingController _etcontents = TextEditingController();
  TextEditingController _etactpernm = TextEditingController();
  TextEditingController _ettel = TextEditingController();
  TextEditingController _etaddrtxt = TextEditingController();
  TextEditingController _etremark = TextEditingController();

  final List<String> _eActperidData = [];
  final List<String> _eActperidData2 = [];

  late String _dbnm;
  String? _etPeridTxt;
  String? _etPeridTxt2;
 bool chk = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pop_epernm();
    pop_eContnm();
    _etrecedate.text = DateTime.now().toString().substring(0,10);
    _ethitchdate.text = DateTime.now().toString().substring(0,10);
  }


  @override
  Future pop_epernm()async {
    try{
      String _dbnm = await  SessionManager().get("dbnm");
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
        _eActperidData2.clear();

        for (int i = 0; i < alllist.length; i++) {
          if (alllist[i]['wperid'] != null || alllist[i]['wperid'].length > 0 ){
            eactpernm_model emObject= eactpernm_model(
                wperid:alllist[i]['wperid'],
                wpernm:alllist[i]['wpernm']
            );
            setState(() {
              ePernmData.add(emObject);
              _eActperidData.add(alllist[i]['wpernm'] + ' [' + alllist[i]['wperid'] + ']' );
              _eActperidData2.add(alllist[i]['wpernm'] + ' [' + alllist[i]['wperid'] + ']' );

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
  Future pop_eContnm()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/wcontnm';
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
        'contnm': '%',
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      eContData.clear();
      _eContData.clear();

      for (int i = 0; i < alllist.length; i++) {
        if (alllist[i]['contcd'] != null || alllist[i]['contcd'].length > 0 ){
          econtnm_model emObject= econtnm_model(
              contcd:alllist[i]['contcd'],
              contnm:alllist[i]['contnm']
          );
          setState(() {
            eContData.add(emObject);
            _eContData.add(alllist[i]['contnm'] + ' [' + alllist[i]['contcd'] + ']' );
            // _etGregicdTxt = alllist[0]['greginm'] + ' [' + alllist[0]['gregicd'] + ']'  ;
          });
        }
      }

      return eContData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      print("error!!!!!!!!!!!!!!!!!!!!!!!");
      throw Exception('고장부위 불러오는데 실패했습니다');

    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



  @override
  Future<bool> save_plandata()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/apppgymobile/save_e401';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");
    if(_etrecedate.text == null || _etrecedate.text == "" ){
      showAlertDialog(context, "접수일자를 기입하세요");
      chk = false;
      return false;
    }
    if(_etrecetime.text == null || _etrecetime.text == "" ){
      showAlertDialog(context, "접수시간을 기입하세요");
      chk = false;
      return false;
    }
    if(_ethitchdate.text == null || _ethitchdate.text == "" ){
      showAlertDialog(context, "고장일자를 입력하십시오.");
      chk = false;
      return false;
    }
    if(_ethitchtime.text == null || _ethitchtime.text == "" ){
      showAlertDialog(context, "고장시간을 입력하십시오.");
      chk = false;
      return false;
    }
    if(_etactnm.text == null  || _etactnm.text == ""){
      showAlertDialog(context, "현장입력을 하십시오");
      chk = false;
      return false;
    }
    if(equpcd == null  || equpcd == ""){
      showAlertDialog(context, "현장조회를 하십시오.");
      chk = false;
      return false;
    }
    if(_etequpnm.text == null  || _etequpnm.text == ""){
      showAlertDialog(context, "현장조회를 하십시오.");
      chk = false;
      return false;
    }
    if(_etContcdTxt == null || _etContcdTxt.toString() == "" ){
      showAlertDialog(context, "고장내용을 확인하십시오.");
      chk = false;
      return false;
    }

    if(_etPeridTxt == null || _etPeridTxt.toString() == ""){
      showAlertDialog(context, "담당자를 확인하십시오.");
      chk = false;
      return false;
    }
    if(_etPeridTxt2 == null || _etPeridTxt.toString() == ""){
      showAlertDialog(context, "접수자를 확인하십시오.");
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
        'recedate':  _etrecedate.text,
        'hitchdate' : _ethitchdate.text,
        'hitchhour' : _ethitchtime.text,
        'perid'  :    _etPeridTxt.toString(),
        'inperid' :   _etPeridTxt2.toString(),
        'cltcd'  : cltcd,
        'actcd'     : actcd,
        'actnm'  : _etactnm.text,
        'equpcd' : equpcd,
        'equpnm' : _etequpnm.text,
        'contcd' : _etContcdTxt.toString(),
        'contents' : _etcontents.text,
        'remark'   : _etremark.text,
        'recetime' : _etrecetime.text,




      },
    );
    if(response.statusCode == 200){
      print("수정됨");
      chk = true;
      Get.off(AppPager16());
      return   true;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      chk = false;
      throw Exception('고장부위 불러오는데 실패했습니다');
      return   false;
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
        title: Text('고장접수등록',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.432,
                child: TextField(
                  controller: _etrecedate,
                  readOnly: true,
                  onTap: () {
                    _selectDateWithMinMaxDate(context);
                  },
                  maxLines: 1,
                  cursorColor: Colors.grey[600],
                  style: TextStyle(fontSize: 16, color: Colors.lightBlue[700]),
                  decoration: InputDecoration(
                      isDense: true,
                      suffixIcon: Icon(Icons.date_range, color: Colors.pinkAccent),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      labelText: '접수일자',
                      labelStyle:
                      TextStyle(color: BLACK_GREY)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 0.381,
                child: TextField(
                  controller: _etrecetime,
                  readOnly: true,
                  onTap: () {
                    _selectTime(context);
                  },
                  maxLines: 1,
                  cursorColor: Colors.grey[600],
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  decoration: InputDecoration(
                      isDense: true,
                      suffixIcon: Icon(Icons.date_range, color: Colors.pinkAccent),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      labelText: '접수시간 *',
                      labelStyle:
                      TextStyle(color: BLACK_GREY)),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.432,
                child: TextField(
                  controller: _ethitchdate,
                  readOnly: true,
                  onTap: () {
                    _selectDateWithMinMaxDate2(context);
                  },
                  maxLines: 1,
                  cursorColor: Colors.grey[600],
                  style: TextStyle(fontSize: 16, color: Colors.lightBlue[700]),
                  decoration: InputDecoration(
                      isDense: true,
                      suffixIcon: Icon(Icons.date_range, color: Colors.pinkAccent),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      labelText: '고장일자',
                      labelStyle:
                      TextStyle(color: BLACK_GREY)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 0.381,
                child: TextField(
                  controller: _ethitchtime,
                  readOnly: true,
                  onTap: () {
                    _selectTime2(context);
                  },
                  maxLines: 1,
                  cursorColor: Colors.grey[600],
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  decoration: InputDecoration(
                      isDense: true,
                      suffixIcon: Icon(Icons.date_range, color: Colors.pinkAccent),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      labelText: '고장시간 *',
                      labelStyle:
                      TextStyle(color: BLACK_GREY)),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etactnm,
            readOnly: false,
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
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager16Actnm(data: _etactnm.text))).then((value) {
              setState(() {
                actcd = value[0];
                actnm = value[1];
                cltcd = value[2];
                equpcd = value[3];
                equpnm = value[4];

                _etequpnm.text = value[4];


                _etactnm.text = value[1];

                /*  actcd2 = value[0];*/

              });

              print(actcd);
              print(equpcd);
              print(actnm);
              print(equpnm);

              print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

            });
          }, child: Text("현장 검색하기")),
          TextField(
            controller: _etequpnm,
            readOnly: true,
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
                labelText: '동호기명',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('고장내용(*)'),
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
                    hint: Text("고장내용", style: TextStyle(color: Colors.white)),
                    value:  this._etContcdTxt != null? this._etContcdTxt :null ,
                    items: _eContData.map((item) {
                      return DropdownMenuItem<String>(
                        child: Text(item, style: TextStyle(color: Colors.white)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        this._etContcdTxt = value;
                        /*widget.e401receData.contcd = value;*/

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
            controller: _etcontents,
            readOnly: false,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '고장상세내용',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('담당자'),
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
                    hint: Text("담당자", style: TextStyle(color: Colors.white)),
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

          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('접수자'),
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
                    hint: Text("접수자", style: TextStyle(color: Colors.white)),
                    value: this._etPeridTxt2 != null? this._etPeridTxt2 :null ,
                    items: _eActperidData2.map((item) {
                      return DropdownMenuItem<String>(
                        child: Text(item, style: TextStyle(color: Colors.white)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        this._etPeridTxt2 = value;
                        /*widget.e401Data.remocd = value;*/   /*****************************************************************************************************************/
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          TextField(
            controller: _etremark,
            readOnly: false,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '비고',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
              Container(
                margin: EdgeInsets.only(left: 5),
                width:  0.38 * MediaQuery.of(context).size.width,
                child: ElevatedButton(onPressed: (){
                  /*Navigator.pop(context);*/
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      content: Text('저장하시겠습니까?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () async {
                            Navigator.pop(context);
                            /*await update_plandata();*/
                              await save_plandata();

                          },
                        ),
                        TextButton(onPressed: (){
                          Navigator.pop(context, "취소");
                        }, child: Text('Cancel')),
                      ],
                    );
                  });
                }, child: Text('저장하기')),
              ),



        ],
      ),
    );
  }

  Future<Null> _selectDateWithMinMaxDate(BuildContext context) async {
    var firstDate = DateTime(initialDate.year, initialDate.month - 3, initialDate.day);
    var lastDate = DateTime(initialDate.year, initialDate.month, initialDate.day + 60);
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



        _etrecedate = TextEditingController(
            text: _selectedDate.toLocal().toString().split(' ')[0]);

      });
    }
  }

  Future<Null> _selectDateWithMinMaxDate2(BuildContext context) async {
    var firstDate = DateTime(initialDate.year, initialDate.month - 3, initialDate.day);
    var lastDate = DateTime(initialDate.year, initialDate.month, initialDate.day + 60);
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



        _ethitchdate = TextEditingController(
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
        _etrecetime.text = _time;
        _erecetime = _hour  + _minute;
        _erecetime =  _hour  + _minute;
        _etrecetime.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }


  Future<Null> _selectTime2(BuildContext context) async {
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
        _ethitchtime.text = _time;
        _ehitchtime = _hour  + _minute;

        _ehitchtime =  _hour  + _minute;
        _ethitchtime.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }


  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('고장처리등록'),
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