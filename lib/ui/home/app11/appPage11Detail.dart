import 'dart:convert';

import 'package:actasm/model/app04/E038List_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/eactpernm_model.dart';
import '../../../model/app02/plan_model.dart';
import '../../../model/app02/tbe601list_model.dart';
import '../../reusable/reusable_widget.dart';
import '../app03/Nav_right.dart';
import 'appPage11.dart';
import 'appPage11Actnm.dart';
import 'appPage11Car.dart';
import 'appPage11Equp.dart';

class AppPage11Detail extends StatefulWidget{

  final E038List_model E038Data;

  const AppPage11Detail({Key? key, required this.E038Data}) : super(key: key);


  @override
  _AppPage11DetailState createState() => _AppPage11DetailState();

}






class _AppPage11DetailState extends State<AppPage11Detail> {
  final _reusableWidget = ReusableWidget();


  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  TextEditingController _etDate = TextEditingController();
  TextEditingController _etactcd = TextEditingController();
  TextEditingController _etactnm = TextEditingController();
  TextEditingController _etequpnm = TextEditingController();
  TextEditingController _etequpcd = TextEditingController();
  TextEditingController _etfrtime = TextEditingController();
  TextEditingController _ettotime = TextEditingController();
  TextEditingController _etcarcd = TextEditingController();
  TextEditingController _etcarnm = TextEditingController();
  TextEditingController _etmemo = TextEditingController();


  String? _ePlandate;

  String equpcd = '';
  String cltcd = '';


  List<tbe601list_model> e601Datas = e601Data;

  final List<String> _eActperidData = [];

  String? _etPeridTxt;
  bool chk = false;

  @override
  void initState(){
    setData();
    pop_epernm();
    super.initState();

  }

  @override
  void setData(){

    _etDate = TextEditingController(text: widget.E038Data.rptdate);
    _etactcd = TextEditingController(text: widget.E038Data.actcd);
    _etactnm = TextEditingController(text: widget.E038Data.actnm);
    _etequpcd = TextEditingController(text: widget.E038Data.equpcd);
    _etequpnm = TextEditingController(text: widget.E038Data.equpnm);
    _etfrtime = TextEditingController(text: widget.E038Data.frtime);
    _ettotime = TextEditingController(text: widget.E038Data.totime);
    _etcarnm = TextEditingController(text: widget.E038Data.carnum);
    _etcarcd = TextEditingController(text: widget.E038Data.carcd);
    _etmemo = TextEditingController(text: widget.E038Data.remark);
  }

  Future<bool> delete_data() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/e038mbc/deleteE038';
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
        'dbnm': _dbnm,
        // 'recedate': widget.e401Data.recedate.toString(),
        // 'recenum': widget.e401Data.recenum.toString(),
        // 'resuremark': widget.e401Data.resuremark.toString(),
        'rptdate': _etDate.text,
        'actcd' : _etactcd.text,
        'equpcd' : _etequpcd.text,
        'carcd' : _etcarcd.text

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
    var uritxt = CLOUD_URL + '/e038mbc/updateE038';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");
    if(_etactcd.text == null || _etactcd == "" ){
      showAlertDialog(context, "현장조회를 하십시오.");
      chk = false;
      return false;
    }
    if(_etactnm.text == null  || _etactnm == ""){
      showAlertDialog(context, "현장조회를 하십시오");
      chk = false;
      return false;
    }
    if(equpcd == null  || equpcd == ""){
      showAlertDialog(context, "현장조회를 하십시오.");
      chk = false;
      return false;
    }
    if(_etequpnm.text == null  || _etequpnm == ""){
      showAlertDialog(context, "현장조회를 하십시오.");
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
        // 'recedate': widget.e401Data.recedate.toString(),
        // 'recenum': widget.e401Data.recenum.toString(),
        // 'resuremark': widget.e401Data.resuremark.toString(),
        'rptdate': _etDate.text,
        'actcd' : _etactcd.text,
        'equpcd' : _etequpcd.text,
        'carcd' : _etcarcd.text,
        'frtime' : _etfrtime.text,
        'totime' : _ettotime.text,
        'remark' : _etmemo.text

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
        title: Text('작업일보조회',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
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
          SizedBox(
            height: 20,
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
                }, child: Text('수정하기')),
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
                }, child: Text('수정하기')),
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
          TextField(
            controller: _etfrtime,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '시작시간 *',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _ettotime,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '종료시간',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
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




          /*TextField(
            controller: _etpernm,
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
                labelText: '담당자',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),*/
          /*SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etkcpernm,
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
                labelText: '검사자',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),*/
          SizedBox(
            height: 20,
          ),

          SizedBox(
            height: 20,
          ),

          SizedBox(
            height: 20,
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
                              await update_plandata();

                              Get.off(AppPage11());
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

                            delete_data();


                            Get.off(AppPage11());
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


        _ePlandate = _selectedDate.toLocal().toString().split(' ')[0];

      });
    }
  }


  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('작업일보수정'),
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