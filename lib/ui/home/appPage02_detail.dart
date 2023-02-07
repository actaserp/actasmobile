import 'dart:convert';
import 'dart:ffi';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/app01/e401list_model.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;

import '../../model/popup/econtnm_model.dart';
import '../../model/popup/egreginm_model.dart';
import '../../model/popup/ereginm_model.dart';
import '../../model/popup/eresultnm_model.dart';
import '../../model/popup/eresunm_model.dart';

class AppPage02Detail extends StatefulWidget {
  final e401list_model e401Data;
  const AppPage02Detail({Key? key, required this.e401Data}) : super(key: key);


  @override
  _AppPage02DetailState createState() => _AppPage02DetailState();
}

class _AppPage02DetailState extends State<AppPage02Detail> {
  // initialize reusable widget
  final _reusableWidget = ReusableWidget();

  // late econtnm_model _selectedContval  ;
  // late econtnm_model _selectedContval = econtnm_model(contcd: null, contnm: null) ;

  final List<String> _eGregiData = [];
  final List<String> _eRegiData = [];
  final List<String> _eResuData = [];
  final List<String> _eResultData = [];
  late String _setTime;
  late String _hour, _minute, _time;
  late String _dbnm , _etrecedate, _etrecenum, _etrectime;
  String? _etGregicdTxt, _etRegicdTxt, _etResucdTxt ,_etResultcdTxt, _eCompdate, _eComptime ;   // _etRegicdTxt, _etResucdTxt, _etResultcdTxt, _etResuremarkTxt;


  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  // create controller to edit text field
  TextEditingController _etActnm = TextEditingController();
  TextEditingController _etContnm = TextEditingController();
  TextEditingController _etContremark = TextEditingController();
  TextEditingController _etContents = TextEditingController();
  TextEditingController _etGregicd = TextEditingController();
  TextEditingController _etResucd = TextEditingController();
  TextEditingController _etRegicd = TextEditingController();
  TextEditingController _etCompdate = TextEditingController();
  TextEditingController _etResultcd = TextEditingController();
  TextEditingController _etResuremark = TextEditingController();
  TextEditingController _etComptime = TextEditingController();


  @override
  void initState() {
    pop_egreginm();
    pop_eresunm();
    pop_eresultnm();
    setData();
    super.initState();
  }
  @override
  void setData(){
    _etActnm = TextEditingController(text: widget.e401Data.actnm);
    _etContnm = TextEditingController(text: widget.e401Data.contnm);
    _etContremark = TextEditingController(text:  widget.e401Data.contremark);
    _etContents = TextEditingController(text: widget.e401Data.contents);
    _etrecedate = widget.e401Data.recedate;
    _etrecenum = widget.e401Data.recenum;
    _etGregicd = TextEditingController(text: '');     // 고장부위
    _etRegicd = TextEditingController(text: '');   // 고자부위상세
    _etResucd = TextEditingController(text: '');    //처리내용
    _etResultcd = TextEditingController(text: '');    //처리결과
    _etResuremark = TextEditingController(text: '');    //처리내용상세

    _etCompdate = TextEditingController(text: _selectedDate.toLocal().toString().split(' ')[0]);
    widget.e401Data.compdate = _selectedDate.toLocal().toString().split(' ')[0];
    _eCompdate = _selectedDate.toLocal().toString().split(' ')[0];
    _etComptime.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    widget.e401Data.comptime = _etComptime;
    _eComptime =  _etComptime.text;
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
  Future<bool> save_e411data()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/savee411';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");
    if(widget.e401Data.compdate == null  ){
      showAlertDialog(context, "처리일자를 등록하세요");
      return false;
    }
    if(widget.e401Data.comptime == null  ){
      showAlertDialog(context, "처리시간을 등록하세요");
      return false;
    }
    if(widget.e401Data.gregicd == null ){
      showAlertDialog(context, "고장부위를 등록하세요");
      return false;
    }
    if(widget.e401Data.regicd == null  ){
      showAlertDialog(context, "고장부위상세를 등록하세요");
      return false;
    }
    if(widget.e401Data.resucd == null  ){
      showAlertDialog(context, "처리내용을 등록하세요");
      return false;
    }
    if(widget.e401Data.resultcd == null  ){
      showAlertDialog(context, "처리결과를 등록하세요");
      return false;
    }
    if(widget.e401Data.resuremark == null  ){
      showAlertDialog(context, "처리상세내용을 등록하세요");
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
        'recedate': widget.e401Data.recedate.toString(),
        'recenum': widget.e401Data.recenum.toString(),
        'compdate': _eCompdate.toString(),
        'comptime': _eComptime.toString(),
        'resuremark': widget.e401Data.resuremark.toString(),
        'resultcd': _etResultcdTxt.toString(),
        'resucd': _etResucdTxt.toString(),
        'regicd': _etRegicdTxt.toString(),
        'gregicd': _etGregicdTxt.toString(),
      },
    );
    if(response.statusCode == 200){
      print("저장됨");
      return   true;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('고장부위 불러오는데 실패했습니다');
      return   false;
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
            '처 리 등 록',
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
                  labelText: '처리일자 *',
                  labelStyle:
                  TextStyle(color: BLACK_GREY)),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _etComptime,
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
                  labelText: '처리시간 *',
                  labelStyle:
                  TextStyle(color: BLACK_GREY)),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _etContnm,
              readOnly: true,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: '고장내용',
                  labelStyle:
                  TextStyle(color: BLACK_GREY)),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _etContents,
              readOnly: true,
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
              child: Text('고장부위'),
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
                          widget.e401Data.gregicd = value;
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
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text('고장부위상세(*)'),
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
                          widget.e401Data.regicd = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
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
                      value: this._etResucdTxt ,
                      items: _eResuData.map((item) {
                        return DropdownMenuItem<String>(
                          child: Text(item, style: TextStyle(color: Colors.white)),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          this._etResucdTxt = value;
                          widget.e401Data.resucd = value;
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
                          widget.e401Data.resultcd = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
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
                widget.e401Data.resuremark = text;
              },
            ),
            SizedBox(
              height: 40,
            ),
            Container(
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
                    bool lb_save = save_e411data() as bool;
                    if (lb_save){
                      _reusableWidget.startLoading(context, '처리등록되었습니다', 1 );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      'Save',
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

        widget.e401Data.compdate  = picked.toLocal().toString().split(' ')[0];
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
        _etrectime = _hour  + _minute;
        widget.e401Data.comptime  = _hour  + _minute;
        _eComptime =  _hour  + _minute;
        _etComptime.text = formatDate(
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
