import 'dart:convert';
import 'dart:ffi';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/ui/home/app11/appPage11Car.dart';
import 'package:actasm/ui/home/app11/appPage11Equp.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../model/app03/MhmanualList_model.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;

import 'appPage11Actnm.dart';


class AppPage11Regist extends StatefulWidget {


  // final MhmanualList_model mhData;
  // const AppPage03Detail({Key? key, required this.mhData}) : super(key: key);

  @override
  _AppPage11RegistState createState() => _AppPage11RegistState();
}

class _AppPage11RegistState extends State<AppPage11Regist> {

  TextEditingController _etDate = TextEditingController();
  late String perid;
  String _efrtime = '';
  String _etotime = '';

  final List<String> _C751Data = [];
  final _reusableWidget = ReusableWidget();
  List<String> _goodParts = [];
  int _maxgoodParts = 2;

  late String _setTime;
  late String _hour, _minute, _time;
  late String _dbnm , _etrecedate, _etrecenum, _etrectime;
  String? _etGregicdTxt, _etRegicdTxt, _etResucdTxt ,_etResultcdTxt, _eCompdate, _eComptime ;   // _etRegicdTxt, _etResucdTxt, _etResultcdTxt, _etResuremarkTxt;


  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedTime2 = TimeOfDay(hour: 00, minute: 00);

  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  List<String> elvlrt = [];

  // 값매핑1
  TextEditingController _etactcd = TextEditingController();
  TextEditingController _etactnm = TextEditingController();
  TextEditingController _etequpnm = TextEditingController();
  TextEditingController _etequpcd = TextEditingController();
  TextEditingController _etfrtime = TextEditingController();
  TextEditingController _ettotime = TextEditingController();
  TextEditingController _etcarcd = TextEditingController();
  TextEditingController _etcarnm = TextEditingController();
  TextEditingController _etmemo = TextEditingController();

  @override
  void initState() {
    sessionData();
    super.initState();

    _etDate.text = DateTime.now().toString().substring(0,4)+DateTime.now().toString().substring(5,7)+DateTime.now().toString().substring(8,10);

  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> sessionData() async{
    perid = (await SessionManager().get("perid")).toString();
    print(perid);
  }

  //저장
  @override
  Future<bool> save_mhdata()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/e038mbc/insertE038';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");
    //null처리
    // if(widget.e401Data.compdate == null  ) {
    //   showAlertDialog(context, "처리일자를 등록하세요");
    //   return false;
    // }
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        // 'recedate': widget.e401Data.recedate.toString(),
        // 'recenum': widget.e401Data.recenum.toString(),
        // 'resuremark': widget.e401Data.resuremark.toString(),
        'actnm' : _etactnm.text,
        'rptdate': _etDate.text,
        'actcd' : _etactcd.text,
        'equpcd' : _etequpcd.text,
        'carcd' : _etcarcd.text,
        'frtime' : _efrtime,
        'totime' : _etotime,
        'remark' : _etmemo.text,
        'perid' : perid
      },
    );
    if(response.statusCode == 200){
      print("저장됨");
      return   true;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('작업일보 저장에 실패했습니다');
      return   false;
    }
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
            '작업일보 등록',
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          bottom: _reusableWidget.bottomAppBar(),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Container(

              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[100]!,
                      width: 1.0,
                    )
                ),
              ),
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              height: kToolbarHeight,
              child: TextField(
                controller: _etDate,
                readOnly: true,
                onTap: () {
                  _selectDateWithMinMaxDate(context);
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
                    labelText: '조회일자',
                    labelStyle:
                    TextStyle(color: BLACK_GREY)),
              ),



            ),


            TextField(
              controller: _etactnm,
              readOnly: false,
              maxLines: 1,
              cursorColor: Colors.grey[600],
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              decoration: InputDecoration(
                  hintText: '현장명을 입력 후 조회하기 버튼을 누르세요.',
                  isDense: true,
                  suffixIcon: TextButton(onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage11Actnm(data: _etactnm.text),
                    ),
                    ).then((value) {
                      setState(() {
                        _etactnm.text = value[1];
                        _etactcd.text = value[0];


                      });
                    });
                  }, child: Text('조회하기')),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  labelText: '현장코드',
                  labelStyle:
                  TextStyle(color: BLACK_GREY)),
            ),


            SizedBox(
              height: 20,
            ),

            TextField(
              controller: _etequpnm,
              readOnly: false,
              maxLines: 1,
              cursorColor: Colors.grey[600],
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              decoration: InputDecoration(
                  hintText: '현장코드를 조회한 후 조회하기 버튼을 누르세요.',
                  isDense: true,
                  suffixIcon: TextButton(onPressed: () async {
                    if(_etactcd.text == null || _etactcd == "" || _etactnm.text ==null || _etactnm == ""){
                      showAlertDialog(context, "현장조회를 하십시오.");
                    }else {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            AppPage11Equp(data: _etactcd.text),
                        ),
                      ).then((value) {
                        setState(() {
                          _etequpcd.text = value[0];
                          _etequpnm.text = value[1];
                        });
                      });
                    }
                  }, child: Text('조회하기')),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  labelText: '호기',
                  labelStyle:
                  TextStyle(color: BLACK_GREY)),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width * 0.381,
              child: TextField(
                controller: _etfrtime,
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
                    labelText: '시작시간 *',
                    labelStyle:
                    TextStyle(color: BLACK_GREY)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width * 0.381,
              child: TextField(
                controller: _ettotime,
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
                    labelText: '종료시간 *',
                    labelStyle:
                    TextStyle(color: BLACK_GREY)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _etcarnm,
              readOnly: false,
              maxLines: 1,
              cursorColor: Colors.grey[600],
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              decoration: InputDecoration(
                  hintText: '차량번호 입력 후 조회하기 버튼을 누르세요.',
                  isDense: true,
                  suffixIcon: TextButton(onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage11Car(data: _etcarnm.text),
                    ),
                    ).then((value) {
                      setState(() {
                        _etcarcd.text = value[0];
                        _etcarnm.text = value[1];


                      });
                    });
                  }, child: Text('조회하기')),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  labelText: '차량',
                  labelStyle:
                  TextStyle(color: BLACK_GREY)),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _etmemo,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: '업무내용 *',
                  labelStyle:
                  TextStyle(color: BLACK_GREY)),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
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
                  onPressed: () {
                    save_mhdata();
                    _reusableWidget.startLoading(context, '등록이 완료되었습니다.', 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      '등록하기',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
              ),
            ),
          ],
        )
    );
  }


//저장시 confirm
  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('작업일보'),
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

        _etDate = TextEditingController(
            text: _selectedDate.toLocal().toString().split('-')[0]+_selectedDate.toLocal().toString().split('-')[1]+_selectedDate.toLocal().toString().split('-')[2].substring(0,2));
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
        if(selectedTime.hour < 10){
          _hour = '0' + selectedTime.hour.toString();
        }else{
          _hour = selectedTime.hour.toString();
        }
        if(selectedTime.minute < 10){
          _minute = '0' + selectedTime.minute.toString();
        }else{
          _minute = selectedTime.minute.toString();
        }
        _time = _hour + ' : ' + _minute;
        _etfrtime.text = _time;
        _efrtime =  _hour  + _minute;

        _etfrtime.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    print(_etfrtime);
    print(_efrtime);
  }


  Future<Null> _selectTime2(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime2,
    );
    if (picked != null)
      setState(() {
        selectedTime2 = picked;
        if(selectedTime2.hour < 10){
          _hour = '0' + selectedTime2.hour.toString();
        }else{
          _hour = selectedTime2.hour.toString();
        }
        if(selectedTime2.minute < 10){
          _minute = '0' + selectedTime2.minute.toString();
        }else{
          _minute = selectedTime2.minute.toString();
        }
        _time = _hour + ' : ' + _minute;
        _ettotime.text = _time;
        _etotime =  _hour  + _minute;
        _ettotime.text = formatDate(
            DateTime(2019, 08, 1, selectedTime2.hour, selectedTime2.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    print(_ettotime);
    print(_etotime);
  }
}
