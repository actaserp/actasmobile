

import 'dart:convert';

import 'package:actasm/config/global_style.dart';
import 'package:actasm/config/constant.dart';
import 'package:actasm/model/app02/books.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../../model/app02/plan_model.dart';
import '../../../model/app04/E038List_model.dart';
import '../../account/tab_account.dart';
import '../tab_home.dart';
import 'appPage11Actnm.dart';
import 'appPage11Detail.dart';
import 'appPage11Regist.dart';
//import 'appPage11_view.dart';



class AppPage11 extends StatefulWidget {
  @override
  _AppPage11State createState() => _AppPage11State();
}

class _AppPage11State extends State<AppPage11> {
  TextEditingController _etDate = TextEditingController();

  List<E038List_model> e038Datas = e038Data;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  bool chk = true;
  String perid = '';


  TextEditingController _etactnm = TextEditingController();

  TextEditingController _etactcd = TextEditingController();




  @override
  void initState(){

    sessionData();
    super.initState();
    e038list_getdata();

  }

  @override
  void dispose(){
    _etDate.dispose();
    e038Data.clear();
    super.dispose();
  }


  Future<void> sessionData() async{
    perid = (await SessionManager().get("perid")).toString();
    print(perid);
  }


  Future e038list_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/e038mbc/list';
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
        'date': _etDate.text,
        'perid': perid,
        'actnm': _etactnm.text
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      e038Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        E038List_model emObject= E038List_model(
          custcd:alllist[i]['custcd'],
          spjangcd:alllist[i]['spjangcd'],
          rptdate:alllist[i]['rptdate'],
          perid:alllist[i]['perid'],
          wkcd:alllist[i]['wkcd'],
          rptnum:alllist[i]['rptnum'],
          actcd:alllist[i]['actcd'],
          actnm:alllist[i]['actnm'],
          frtime:alllist[i]['frtime'],
          totime:alllist[i]['totime'],
          carcd:alllist[i]['carcd'],
          carnum:alllist[i]['carnum'],
          remark:alllist[i]['remark'],
          filenum:alllist[i]['filenum'],
          equpcd:alllist[i]['equpcd'],
          startkm:alllist[i]['startkm'],
          endkm:alllist[i]['endkm'],
          km:alllist[i]['km'],
          cltcd:alllist[i]['cltcd'],
          pernm:alllist[i]['pernm'],
          equpnm:alllist[i]['equpnm']
        );
        setState(() {
          e038Data.add(emObject);
        });

      }
      return e038Data;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }


  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: GlobalStyle.appBarIconThemeColor,
          ),
          elevation: GlobalStyle.appBarElevation,
          title: Text(
            '작업일보',
            style: GlobalStyle.appBarTitle,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(onPressed: (){

                setState(() {
                  chk = true;
                  e038list_getdata();
                });
                /*searchBook(_etSearch.text);*/
                /*searchBook2(_etSearch2.text);*/
              }, child: const Text('검색하기')),
            )
            /*IconButton(onPressed: (){
              print('검색');
            }, icon: Icon(Icons.search))*/
          ],
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,

        ),
        body:
        Padding(
        padding: EdgeInsets.all(16.0),
        child:
          WillPopScope(
            onWillPop: (){
              Navigator.pop(context);
              return Future.value(true);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
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
                          labelStyle: TextStyle(color: BLACK_GREY),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _etDate.text = "";
                          _etactnm.text = "";

                          chk = true;
                          e038list_getdata();
                        });
                      },
                      child: Text(
                        '전체조회',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xffcccccc),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child:
                TextField(
                  controller: _etactnm,
                  readOnly: false,
                  maxLines: 1,
                  cursorColor: Colors.grey[600],
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  decoration: InputDecoration(
                      hintText: '현장명을 입력 후 조회하기 버튼을 누르세요.',
                      isDense: true,
                      labelText: '현장명',
                      labelStyle:
                      TextStyle(color: BLACK_GREY)),
                ),
                ),




                chk ? Expanded(

                  child: ListView.builder(itemCount: e038Datas.length,
                    // padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index){
                      return _buildListCard(e038Datas[index]);
                    },
                  ),
                ) : Text("자료를 검색하세요."),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: Container( ///노하우등록
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(12),
                          child: OutlinedButton(
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage03Detail(MhData: MhData, MhData: null,)));
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AppPage11Regist()));
                              },
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      )
                                  ),
                                  side: MaterialStateProperty.all(
                                    BorderSide(
                                        color: SOFT_BLUE,
                                        width: 1.0
                                    ),
                                  )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  '작업일보 등록',
                                  style: TextStyle(
                                      color: SOFT_BLUE,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                          ),
                        )
                    )
                  ]
                ),


              ],
            ),

          ),
        ),
      bottomNavigationBar:  BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) { // 1번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AppPage11()));          }
          if (index == 1) { // 2번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TabHomePage()));          }
          if (index == 2) { // 3번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TabAccountPage()));            }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: '새로고침',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),


    );

  }


  void searchBook(String query){
    final suggestions = e038Datas.where((data) {
      final bookTitle = data.actnm.toString();
      final input = query.toString();
      return bookTitle.contains(input);
    }).toList();

    setState(() => e038Datas = suggestions);
  }

  /*void searchBook2(String query){
    final suggestions = MData.where((data) {
      final greginmtitle = data.greginm.toString();
      final input = query.toString();
      return greginmtitle.contains(input);
    }).toList();

    setState(() => mhDatas = suggestions);
  }*/





  Widget _buildListCard(E038List_model e038Data){
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
          //Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage11view(e038Data: e038Data)));
        },
        child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage11Detail(E038Data: e038Data)));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e038Data.actnm, style: GlobalStyle.couponName),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GlobalStyle.iconTime,
                      SizedBox(
                        width: 4,
                      ),
                      Text(e038Data.rptdate+' ', style: GlobalStyle.couponExpired),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage11Detail(E038Data: e038Data)));
                    },
                    child: Text(e038Data.pernm, style: TextStyle(
                        fontSize: 14, color: SOFT_BLUE, fontWeight: FontWeight.bold
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

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
}

