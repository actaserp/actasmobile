import 'dart:convert';
import 'dart:ffi';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../model/app03/MhmanualList_model.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;

import '../../../model/popup/Comm754_model.dart';

class AppPage04Detail extends StatefulWidget {
  @override
  _AppPage04DetailState createState() => _AppPage04DetailState();
}

class _AppPage04DetailState extends State<AppPage04Detail> {

  final List<String> _C754Data = [];
  final _reusableWidget = ReusableWidget();

  late String _dbnm  ;
  String? _codeTxt, _eCompdate;
  ///작성자
  var _usernm = "";
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();


  TextEditingController _memo = TextEditingController();
  TextEditingController _subject = TextEditingController();
  TextEditingController _etCompdate = TextEditingController();


  @override
  void initState() {
    sessionData();
    pop_Com751();
    super.initState();
  }
  @override
  Future<void> sessionData() async {
    String username = await  SessionManager().get("username");
    _usernm = utf8.decode(username.runes.toList());
  }
  @override
  Future pop_Com751()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/Com754to01';
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
        'cnam': '%',
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      C754Data.clear();
      _C754Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        if (alllist[i]['code'] != null || alllist[i]['code'].length > 0 ){
          Comm754_model emObject= Comm754_model(
              code:alllist[i]['code'],
              cnam:alllist[i]['cnam']
          );
          setState(() {
            C754Data.add(emObject);
            _C754Data.add(alllist[i]['code'] + '[' + alllist[i]['cnam'] + ']');
          });
        }
      }

      return C754Data;
    }else{
      throw Exception('분류 코드를 불러오는데 실패했습니다');
    }
  }

  @override
  Future<bool> save_mBdata()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/saveeMB';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");
    ///null처리
    if(_codeTxt == null || _codeTxt == "" ) {
      showAlertDialog(context, "분류를 선택하세요");
      return false;
    }
    if(_etCompdate.text == null || _etCompdate.text == "") {
      showAlertDialog(context, "작성일자를 입력하세요");
      return false;
    }
    if(_subject == null || _subject == "" ) {
      showAlertDialog(context, "제목을 입력하세요");
      return false;
    }
    if(_memo == null || _memo == "" ) {
      showAlertDialog(context, "내용을 입력하세요");
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
        'binputdate': _etCompdate.text.toString(),
        'bpernm': _usernm.toString(),
        'bmemo': _memo.text.toString(),
        'bsubject': _subject.text.toString(),
        'bgroupcd': this._codeTxt.toString().substring(0,2),
      },
    );
    if(response.statusCode == 200){
      print("저장됨");
      return   true;
    }else{
      throw Exception('부품가이드 저장에 실패했습니다');
    }
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
            '가이드 등록',
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          bottom: _reusableWidget.bottomAppBar(),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
                    Card(
                      color: SOFT_BLUE,
                      elevation: 5,
                      child:
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: Icon(Icons.keyboard_arrow_down),
                            dropdownColor: Colors.blue[800],
                            iconEnabledColor: Colors.white,
                            hint: Text("분류 *", style: TextStyle(color: Colors.white)),
                            value: this._codeTxt != null? this._codeTxt :null ,
                            items: _C754Data.map((item) {
                              return DropdownMenuItem<String>(
                                child: Text(item, style: TextStyle(color: Colors.white)),
                                value: item,
                              );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              this._codeTxt = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                        Row(
                          children: [
                            Text( _usernm,
                              style: TextStyle(color: SOFT_BLUE ,fontSize: 18,fontWeight: FontWeight.bold),
                            ),
                            Text( '님이 작성 중입니다.',
                              style: TextStyle(color: BLACK_GREY ,fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
            TextField(
              controller: _etCompdate,
              readOnly: true,
              onTap: () {
                _selectDateWithMinMaxDate(context);
              },
              maxLines: 1,
              cursorColor: Colors.grey[600],
              style: TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                // fillColor: Colors.grey[200],
                // filled: true,
                  isDense: true,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '작성일자를 입력하세요',
                  suffixIcon: Icon(Icons.date_range, color: Colors.pinkAccent),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  labelText: '작성일자 *',
                  labelStyle:
                  TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _subject,
              autofocus: true,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '제목을 작성하세요',
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: '제목 *',
                  labelStyle:
                  TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              autofocus: true,
              controller: _memo,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '내용을 작성하세요',
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: '내용 *',
                  labelStyle:
                  TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
            ),
                          SizedBox(
                            height: 20,
                          ),
                  ///등록 시작
                  SizedBox(
                    height: 40,
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
                        onPressed: ()async  {
                          bool lb_save = await save_mBdata();
                          if (lb_save){
                            _reusableWidget.startLoading(context, '처리등록되었습니다', 1 );
                          }
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
          title: Text('부품가이드'),
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
  ///datepicker
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
        _eCompdate = _selectedDate.toLocal().toString().split(' ')[0];
        _etCompdate = TextEditingController(
            text: _selectedDate.toLocal().toString().split(' ')[0]);
      });
    }
  }
}
