import 'dart:convert';

import 'package:actasm/model/app02/plan_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';

import '../../../model/app02/eactpernm_model.dart';
import '../../../model/app02/plan_model.dart';
import '../../../model/app02/tbe601list_model.dart';
import '../../reusable/reusable_widget.dart';
import 'appPager15Actnm.dart';

class AppPager15register extends StatefulWidget {

  const AppPager15register({Key? key,  data}) : super(key: key);
  // final MhmanualList_model mhData;
  // const AppPage03Detail({Key? key, required this.mhData}) : super(key: key);

  @override
  _AppPager15registerState createState() => _AppPager15registerState();

}

class _AppPager15registerState extends State<AppPager15register> {
  final _reusableWidget = ReusableWidget();
  late String _hour, _minute, _time;
  late String _dbnm;
  String? _eCompdate;
  List<String> elvlrt = [];

  String actcd = "";
  String actnm  ="";
  String equpcd = "";
  String equpnm = "";



  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  TextEditingController _etCompdate = TextEditingController();
  TextEditingController _etSearch2 = TextEditingController();
  TextEditingController _etqty = TextEditingController();
  TextEditingController _etText = TextEditingController();

  List<tbe601list_model> e601Datas = e601Data;

  final List<String> _eActperidData = [];

  String? _etPeridTxt;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pop_epernm();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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


  Future getactnminfo() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/tbe601list';
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
        'actnm': _etSearch2.text,


      },
    );
    if(response.statusCode == 200){

      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      e601Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        tbe601list_model emObject= tbe601list_model(

          equpnm:    alllist[i]["equpnm"],
          actnm :    alllist[i]["actnm"],
          actaddr  : alllist[i]["actaddr"],
          pernm:    alllist[i]["pernm"],
          actcd:    alllist[i]["actcd"],
          equpcd:    alllist[i]["equpcd"]

        );
        setState(() {
          e601Data.add(emObject);
        });

        print("check");
        print(e601Datas.length);
      }
      return e601Data;
    }else{
      throw Exception('불러오는데 실패했습니다.');
    }
  }


  @override
  Future<bool> save_e411data()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/apppgymobile/mfixsave';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");
    /*if(widget.e401Data.compdate == null  ){
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
    }*/
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
            'dbnm': _dbnm,
        'plandate':  _etCompdate.text,
        'actcd' : actcd.toString(),
        'actnm' : actnm.toString(),
        'equpcd' : equpcd.toString(),
        'equpnm' : equpnm.toString(),
        'perid'   : _etPeridTxt.toString(),
        'kcpernm' : _etPeridTxt.toString(),
        'remark'  : _etText.text.toString(),
        'qty'     : _etqty.text.toString(),

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
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text(
          '점검계획  등록',
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
                labelText: '계획일자 *',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[100]!,
                    width: 1.0,
                  )
              ),
            ),
            padding: EdgeInsets.fromLTRB(0, 0, 16, 12),
            height: kToolbarHeight,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6 ,
                  child: TextField(
                    controller: _etSearch2,
                    textAlignVertical: TextAlignVertical.bottom,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),

                    /*onChanged: searchBook,*/
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      hintText: '현장조회',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      suffixIcon: (_etSearch2.text == '')
                          ? null
                          : GestureDetector(
                          onTap: () {
                            setState(() {
                              _etSearch2 = TextEditingController(text: '');
                            });
                          },
                          child: Icon(Icons.close, color: Colors.grey[500])),
                      focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.blue[800]!)),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: ElevatedButton(
                    onPressed: ()  async {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager15Actnm(data: _etSearch2.text),
                      ),
                      ).then((value) {

                           actcd = value[0];
                           equpcd = value[1];
                           actnm = value[2];
                           equpnm = value[3];
                          print(actcd);
                          print(equpcd);
                          print(actnm);
                          print(equpnm);

                          print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

                      });

                      /*await getactnminfo();


                      Future.delayed(Duration(milliseconds: 700), (){
                        if(e601Data.length == 0){
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              content: Text('유효하지 않습니다.'),
                            );
                          });
                        }

                      });


                    *//*Future.delayed(Duration(milliseconds: 300), (){

                    });*//*
                      showAlertDialog(context);
*/

                    },
                    child: Text('조회하기'),
                  ),
                )
              ],
            ),
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

          TextField(
            controller: _etqty,
            readOnly: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '관리대수 (숫자만 입력하세요.)',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
            onChanged: (text){
              /* _etremoremark.text = text;   */                                   /**************************************************************************************/
            },
          ),
          TextField(
            controller: _etText,
            readOnly: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '기타호기 ',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
            onChanged: (text){
              /* _etremoremark.text = text;   */                                   /**************************************************************************************/
            },
          ),
          SizedBox(
            height: 30,
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

                  save_e411data();
                  /*bool lb_save = save_e411data() as bool;
                  if (lb_save){
                    _reusableWidget.startLoading(context, '처리등록되었습니다', 1 );
                  }*/
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


        _eCompdate = _selectedDate.toLocal().toString().split(' ')[0];
        _etCompdate = TextEditingController(
            text: _selectedDate.toLocal().toString().split(' ')[0]);
      });
    }
  }


  void showAlertDialog(BuildContext context) async {



    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('보수현장정보'),

          content:

             SizedBox(
               height: 400,
               width: 500,
               child: ListView.builder(itemCount: e601Datas.length,
                 padding: EdgeInsets.fromLTRB(16, 0, 16, 16),

                 physics:  AlwaysScrollableScrollPhysics(),
                 itemBuilder: (BuildContext context, int index){
                   return _buildListCard(e601Datas[index]);
                 },
               ),
             ),


          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                elvlrt.clear();
                Navigator.pop(context, "확인");

              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildListCard(tbe601list_model e601Data){
    return Card(
      margin: EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 2,
      color: Colors.white,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){

        },
        child: Container(
          height: 160,
          width: 400,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(child: Text(e601Data.actnm, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), ),
              onPressed: (){
                Navigator.pop(context, MaterialPageRoute(builder: (context) => AppPager15register(data : e601Data.actcd)));
                print(e601Data.actcd);
              },),
              Text('현장코드: ' + e601Data.actcd, style: GlobalStyle.couponName),


              // Text(e401Data.contents, style: GlobalStyle.couponName),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Text('호기명  '+e601Data.equpnm+' ', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), ),


                    ],
                  ),

                ],
              ),
              Text('호기코드: '+e601Data.equpcd+' ', style: GlobalStyle.couponName),

            ],
          ),
        ),
      ),
    );
  }


}