import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/e411list_model2.dart';
import '../app03/Nav_right.dart';
import 'appPager17Detail.dart';

class AppPager17 extends StatefulWidget {
  @override
  _AppPager17State createState() => _AppPager17State();
}

class _AppPager17State extends State<AppPager17> {

  TextEditingController _etSearch = TextEditingController();

  late String perid;
  late String perid2;
  late String username;
  late String username2;

  bool chk = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _initalizeState();

      /*sessionData();
      getdate();*/

    });
  }


  Future<void> _initalizeState() async {
    await sessionData();
    await sessionData2();
    await e401list_getdata();
  }

  Future<void> sessionData2() async {

    if(chk == true){
      username  = '%';
    }
    username = (await SessionManager().get("username")).toString();
    username = utf8.decode(username.codeUnits);
    username2 = (await SessionManager().get("username")).toString();
    username2 = utf8.decode(username2.codeUnits);


    // 문자열 디코딩

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  Future<void> sessionData() async {

    if(chk == true){
      perid = '%';
    }
    perid = (await SessionManager().get("perid")).toString();
    perid2 = (await SessionManager().get("perid")).toString();
    // 문자열 디코딩

  }

  Future getdate() async {
    await e401list_getdata();
  }



  Future e401list_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/apppgymobile/e411_list';
    var encoded = Uri.encodeFull(uritxt);

    Uri uri = Uri.parse(encoded);

    if(chk == true){
      perid = '%';
      username = '%';
    }else if(chk == false){
      perid = perid2;
      username = username2;
    }

    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'actnm': _etSearch.text,
        'perid' : perid,
        'pernm' : username
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      e411Data2.clear();
      for (int i = 0; i < alllist.length; i++) {
        e411list_model2 emObject= e411list_model2(
            compdate: alllist[i]['compdate'],
            compnum:  alllist[i]['compnum'],
            recedate: alllist[i]['recedate'],
            recenum:  alllist[i]['recenum'],
            perid:    alllist[i]['perid'],
            pernm:    alllist[i]['pernm'],
            actcd:    alllist[i]['actcd'],
            actnm:    alllist[i]['actnm'],
            equpnm:   alllist[i]['equpnm'],
          equpcd:     alllist[i]['equpcd'],
          remoremark: alllist[i]['remoremark'],
          resucd:     alllist[i]['resucd'],
          resunm:     alllist[i]['resunm'],
          resuremark: alllist[i]['resuremark'],
          gregicd:    alllist[i]['gregicd'],
          greginm:    alllist[i]['greginm'],
          regicd:   alllist[i]['regicd'],
          reginm:  alllist[i]['reginm'],
          remocd:  alllist[i]['remocd'],
          remonm:  alllist[i]['remonm'],
          resultcd: alllist[i]['resultcd'],
          resultnm: alllist[i]['resultnm'],
          arrivtime: alllist[i]['arrivtime'],
          comptime: alllist[i]['comptime']

        );
        setState(() {
          e411Data2.add(emObject);
        });

      }
      return e411Data2;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      endDrawer: Nav_right(
        text: Text('app03_nav'),
        color: SOFT_BLUE,
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text(
          '고장 처리 리스트 ' + e411Data2.length.toString(),
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        bottom: PreferredSize(child: Row(
          children: [
            Container(
              width: 300,
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
              child: TextFormField(
                controller: _etSearch,
                textAlignVertical: TextAlignVertical.bottom,
                maxLines: 1,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                onChanged: (textValue) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey[300],
                  filled: true,
                  hintText: '보수현장명',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  suffixIcon: (_etSearch.text == '')
                      ? null
                      : GestureDetector(
                      onTap: () {
                        setState(() {
                          _etSearch = TextEditingController(text: '');
                        });
                      },
                      child: Icon(Icons.close, color: Colors.grey[500])),
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.grey[200]!)),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.178,
              margin: EdgeInsets.only(bottom: 10),
              child: TextButton(onPressed: (){
                setState(() {

                  if(_etSearch.text == ""){
                    showAlertDialog(context, "현장명을 입력하세요.");
                  }

                  e401list_getdata();
                });
              }, child: Text('검색하기')),
            )
          ],
        ), preferredSize: Size.fromHeight(kToolbarHeight)),
      ),
      body:



             Column(
               children: [
                 Container(
                   height: MediaQuery.of(context).size.height * 0.7407,
                   child: WillPopScope(
                    onWillPop: (){
                      Navigator.pop(context);
                      return Future.value(true);
                    },
                    child: ListView.builder(
                      itemCount: e411Data2.length,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      physics: AlwaysScrollableScrollPhysics(),
                      // Add one more item for progress indicator
                      itemBuilder: (BuildContext context, int index) {
                        return _buildListCard(e411Data2[index]);
                      },
                    ),


            ),
                 ),
                 Container(
                    child: Row(
                       children: [
                         Expanded(
                           child: Container(
                               child: ElevatedButton(onPressed: (){
                                 chk = true;
                                 setState(() {
                                   e401list_getdata();
                                 });
                               }, child: Text("전체보기"))
                           ),
                         ),
                         Expanded(
                           child: Container(
                             child: ElevatedButton(onPressed: (){
                               chk = false;
                               setState(() {
                                 e401list_getdata();
                               });
                             }, child: Text('내것만 보기'), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent)),
                           ),
                         )
                       ],
                     )
                 ),
               ],
             ),



    );
  }

  Widget _buildListCard(e411list_model2 e411Data){
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager17Detail(e411Data: e411Data)));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e411Data.actnm, style: GlobalStyle.couponName),
              Text('접수날짜: ' + e411Data.recedate, style: GlobalStyle.couponName),
              // Text(e401Data.contents, style: GlobalStyle.couponName),
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
                      Text('처리일자  '+e411Data.compdate, style: GlobalStyle.couponExpired),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      // Fluttertoast.showToast(msg: 'Coupon applied', toastLength: Toast.LENGTH_LONG);

                    },
                    child: Text(e411Data.pernm, style: TextStyle(
                        fontSize: 14, color: SOFT_BLUE, fontWeight: FontWeight.bold
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('고장처리조회'),
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
