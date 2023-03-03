import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/e401recelist_model.dart';
import '../../../model/app02/eactpernm_model.dart';
import '../app03/Nav_right.dart';

class AppPager16Detail extends StatefulWidget {

  final e401recelist_model e401receData;

  const AppPager16Detail({Key? key, required this.e401receData}) : super(key: key);

  // final MhmanualList_model mhData;
  // const AppPage03Detail({Key? key, required this.mhData}) : super(key: key);

  @override
  _AppPager16DetailState createState() => _AppPager16DetailState();

}

class _AppPager16DetailState extends State<AppPager16Detail> {



  late String _hour, _minute, _time;
  String _erecetime = '';
  String _ehitchtime = '';


  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

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

  List<e401recelist_model> e401receDatas = e401receData;

  final List<String> _eActperidData = [];

  String? _etPeridTxt;
  bool chk = true;



  @override
  void initState() {
    setData();
    super.initState();
    pop_epernm();

  }


  @override
  void setData(){
    _etrecedate = TextEditingController(text: widget.e401receData.recedate);
    _etrecetime = TextEditingController(text: widget.e401receData.recetime.toString().substring(0,2)+":"+ widget.e401receData.recetime.toString().substring(2,4));
    _ethitchdate = TextEditingController(text: widget.e401receData.hitchdate);
    _ethitchtime = TextEditingController(text: widget.e401receData.hitchhour.toString().substring(0,2)+":"+ widget.e401receData.hitchhour.toString().substring(2,4));
    _etactnm = TextEditingController(text: widget.e401receData.actnm);
    _etequpnm = TextEditingController(text: widget.e401receData.equpnm);
    _etcontnm = TextEditingController(text: widget.e401receData.contnm);
    _etcontents = TextEditingController(text: widget.e401receData.contents);
    _etPeridTxt = widget.e401receData.actpernm + " [" + widget.e401receData.perid + "]";
    _ettel = TextEditingController(text: widget.e401receData.tel);
    _etaddrtxt = TextEditingController(text:  widget.e401receData.addrtxt);
  }

  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context){
    return Scaffold(
      endDrawer: Nav_right(text: Text('app03_nav'),
        color: SOFT_BLUE,),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,

        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text('고장접수상세조회',
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
          TextButton(onPressed: (){}, child: Text("data")),
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
          TextField(
            controller: _etcontnm,
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
            controller: _etcontents,
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

          TextField(
            controller: _ettel,
            readOnly: true,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '연락처',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _etaddrtxt,
            readOnly: true,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '주소',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
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
                             /* await update_plandata();

                              Get.off(AppPager15());*/
                              if(chk == true) {
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
                                    content: Text('입력값이 잘못되었습니다.'),
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
                      content: Text('삭제하시겠습니까?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {

                           /* delete_data();


                            Get.off(AppPager15());*/
                            /*delete_data();
                             Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => AppPager13()),
                            );
                            Get.off(AppPager13());*/
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
        widget.e401receData.recetime  = _hour  + _minute;
        _erecetime =  _hour  + _minute;
        _etrecetime.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        widget.e401receData.recetime = _etrecetime.text.toString();
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
        widget.e401receData.hitchhour  = _hour  + _minute;
        _ehitchtime =  _hour  + _minute;
        _ethitchtime.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        widget.e401receData.hitchhour = _ethitchtime.text.toString();
      });
  }
}