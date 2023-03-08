import 'dart:convert';

import 'package:actasm/config/global_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../model/app01/e401list_model.dart';
import '../../../model/app02/e401recelist_model.dart';
import 'appPager16Detail.dart';
import 'appPager16register.dart';

class AppPager16 extends StatefulWidget {


  @override
  _AppPager16State createState() => _AppPager16State();
}

class _AppPager16State extends State<AppPager16> {

  TextEditingController _etSearch = TextEditingController();
  late String perid;
  late String perid2;
  late String username;
  late String username2;

  bool chk = false;

  @override
  void initState() {

    super.initState();
    _initalizeState();
    /*sessionData();
    e401list_getdata();*/



  }

  Future<void> _initalizeState() async {
    await sessionData();
    await sessionData2();
    await e401list_getdata();
  }

  @override
  void dispose() {

    _etSearch.dispose();
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




  Future e401list_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/apppgymobile/recelist';
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
        'perid': perid,
        'pernm': username
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      e401receData.clear();
      for (int i = 0; i < alllist.length; i++) {
        e401recelist_model emObject= e401recelist_model(
              recedate: alllist[i]['recedate'],
              recedateyear: alllist[i]['recedateyear'],
              hitchdate: alllist[i]['hitchdate'],
              hitchhour: alllist[i]['hitchhour'],
              recenum: alllist[i]['recenum'],
              actcd:  alllist[i]['actcd'],
              actnm: alllist[i]['actnm'],
              equpcd: alllist[i]['equpcd'],
              equpnm: alllist[i]['equpnm'],
              actpernm: alllist[i]['actpernm'],
              contcd: alllist[i]['contcd'],
              contnm: alllist[i]['contnm'],
              tel: alllist[i]['tel'],
              perid: alllist[i]['perid'],
              pernm: alllist[i]['pernm'],
              reperid: alllist[i]['reperid'],
              recetime: alllist[i]['recetime'],
              repernm: alllist[i]['repernm'],
              contents: alllist[i]['contents'],
              addrtxt: alllist[i]['addrtxt'],
              cltcd: alllist[i]['cltcd']
        );
        setState(() {
          e401receData.add(emObject);
        });

      }
      print(perid);
      return e401receData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
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
            '고장 접수 리스트 ' + e401receData.length.toString(),
            style: GlobalStyle.appBarTitle,
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(onPressed: (){
                    setState(() {
                      e401list_getdata();
                    });
                }, child: Text('검색하기')),
            )
          ],
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          bottom: PreferredSize(child: Container(
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
              style: TextStyle(  fontSize: 16, color: Colors.grey[600]),
              onChanged: (textValue){

              },
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
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
          ), preferredSize: Size.fromHeight(kToolbarHeight)),
        ),
      body: Container(
        height: 800,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.615,
              child: WillPopScope(
                  child: ListView.builder(
                    itemCount: e401receData.length,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _buildListCard(e401receData[index]);
                    },
                  ),
                  onWillPop: (){
                    Navigator.pop(context);
                    return Future.value(true);
              }),
            ),
            Container( ///노하우등록
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager16register()));

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
                          '고장접수 등록',
                          style: TextStyle(
                              color: SOFT_BLUE,
                              fontWeight: FontWeight.bold,
                              fontSize: 13
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                  Row(
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
                ],
              ),
            )
          ],
        ),
      ),

    );
  }


  Widget _buildListCard(e401recelist_model e401receData){
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager16Detail(e401receData: e401receData)));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e401receData.recedate + '(' +e401receData.recetime.toString().substring(0,2) +':' + e401receData.recetime.toString().substring(2,4)  + ')', style: GlobalStyle.couponName),
              Text(e401receData.actnm, style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
              Text('[' + e401receData.contnm + '] ' + e401receData.contents, style: GlobalStyle.couponName),
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
                      Text('전화번호  '+e401receData.tel+' ' , style: GlobalStyle.couponExpired),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      // Fluttertoast.showToast(msg: 'Coupon applied', toastLength: Toast.LENGTH_LONG);

                    },
                    child: Text(e401receData.actpernm, style: TextStyle(
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
}
