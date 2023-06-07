import 'dart:convert';

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
import 'appPager13.dart';
import 'appPager15.dart';
import 'appPager15Actnm.dart';

class AppPager15Detail extends StatefulWidget{

  final plan_model planData;

  const AppPager15Detail({Key? key, required this.planData}) : super(key: key);


  @override
  _AppPager15DetailState createState() => _AppPager15DetailState();

}






class _AppPager15DetailState extends State<AppPager15Detail> {
  final _reusableWidget = ReusableWidget();


  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  TextEditingController _etplandate = TextEditingController();
  TextEditingController _etactcd = TextEditingController();
  TextEditingController _etactnm = TextEditingController();
  TextEditingController _etequpcd = TextEditingController();
  TextEditingController _etequpnm = TextEditingController();
  TextEditingController _etpernm = TextEditingController();
  TextEditingController _etkcpernm = TextEditingController();
  TextEditingController _etkcspnm = TextEditingController();
  TextEditingController _etremark = TextEditingController();
  TextEditingController _etqty = TextEditingController();


  String? _ePlandate;

  String equpcd = '';
  String cltcd = '';


  List<tbe601list_model> e601Datas = e601Data;

  final List<String> _eActperidData = [];

  String? _etPeridTxt;
  bool chk = true;

  @override
  void initState(){
    setData();
    pop_epernm();
    super.initState();
    cltcd = widget.planData.cltcd;
    equpcd = widget.planData.equpcd;
  }

  @override
  void setData(){

    _etplandate = TextEditingController(text: widget.planData.plandate);
    _etactcd = TextEditingController(text: widget.planData.actcd);
    _etactnm = TextEditingController(text: widget.planData.actnm);
    _etequpcd = TextEditingController(text: widget.planData.equpcd);
    _etequpnm = TextEditingController(text: widget.planData.equpnm);
    _etpernm = TextEditingController(text: widget.planData.pernm);
    _etkcpernm = TextEditingController(text: widget.planData.kcpernm);
    _etkcspnm = TextEditingController(text: widget.planData.kcspnm);
    _etremark = TextEditingController(text: widget.planData.remark);
    _etqty = TextEditingController(text: widget.planData.qty);
    _etPeridTxt = widget.planData.kcpernm + " [" + widget.planData.perid + "]";
  }

  Future<bool> delete_data() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/apppgymobile/mfixdelete';
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
        'plandate'    :  widget.planData.plandate,
        'actcd'       :  widget.planData.actcd,
        'equpcd'      :  widget.planData.equpcd

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
    var uritxt = CLOUD_URL + '/apppgymobile/updateplan';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");
    /*if(_etplandate.text == null || _etplandate.text == "" ){
      showAlertDialog(context, "계획일자를 기입하세요");
      chk = false;
      return false;
    }
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
    */

    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'plandate':  _etplandate.text,
        'actcd' : _etactcd.text,
        'actnm' : _etactnm.text,
        'cltcd'  : cltcd,
        'perid'   : _etPeridTxt.toString(),
        'kcpernm' : _etPeridTxt.toString(),
        'remark'  : _etremark.text,
        'qty'     : _etqty.text,
        'kcspnm'  : _etkcspnm.text,
        'plandate2' : widget.planData.plandate,
        'cltcd2' : widget.planData.cltcd,
        'actcd2' : widget.planData.actcd,
        'equpcd2' : widget.planData.equpcd,

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
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => AppPager15()));
        }, icon: Icon(Icons.arrow_back_ios)),
        title: Text('점검계획조회',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: _etplandate,
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
                labelText: '검사일자',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etactcd,
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
                labelText: '현장코드',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
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
                isDense: true,
                suffixIcon: TextButton(onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager15Actnm(data: _etactnm.text),
                  ),
                  ).then((value) {
                    setState(() {
                      _etactnm.text = value[1];
                      _etactcd.text = value[0];
                      cltcd = value[2];

                    });
                  });
                }, child: Text('검색하기')),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '현장명',
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
          TextField(
            controller: _etkcspnm,
            readOnly: false,
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
                labelText: '점검내용',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etremark,
            readOnly: false,
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
                labelText: '보조자 ',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etqty,
            readOnly: false,
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
                labelText: '관리대수(숫자로만 입력)',
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
                            await update_plandata();
                            Navigator.pop(context);

                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppPager15()));

                            //Get.off(AppPager15());
                            if(chk == true) {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  content: Text('수정되었습니다.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                         Navigator.pop(context);

                                         /*Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => AppPager15()),
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
/*
                                         Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => AppPager15()),
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

                            Navigator.pop(context, "확인");
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppPager15()));

                            //Get.off(AppPager15());
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
        _etplandate = TextEditingController(
            text: _selectedDate.toLocal().toString().split(' ')[0]);
      });
    }
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