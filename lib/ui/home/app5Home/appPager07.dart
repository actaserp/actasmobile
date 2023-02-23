

import 'dart:convert';

import 'package:actasm/config/global_style.dart';
import 'package:actasm/config/constant.dart';
import 'package:actasm/model/app02/books.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../../model/app02/e411list_model.dart';
import 'appPager07_detail.dart';


class AppPager07 extends StatefulWidget {
  @override
  _AppPager07State createState() => _AppPager07State();
}

class _AppPager07State extends State<AppPager07> {
  TextEditingController _etSearch = TextEditingController();
  TextEditingController _etSearch2 = TextEditingController();
  List<e411list_model> e411Datas = e411Data;
  List<Book> books = allBooks;
  bool chk = false;



  @override
  void initState(){
    super.initState();
    e411list_getdata();

  }

  @override
  void dispose(){
    _etSearch.dispose();
    e411Data.clear();
    super.dispose();
  }

  Future e411list_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/e411list';
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
        'actnm': _etSearch.text,
        'contnm': _etSearch2.text,

      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      e411Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        e411list_model emObject= e411list_model(
          actnm        : alllist[i]['actnm'],
          compdate       : alllist[i]['compdate'],
          contnm       : alllist[i]['contnm'],
          contents      : alllist[i]['contents'],
          resunm      : alllist[i]['resunm'],
          resuremark       : alllist[i]['resuremark'],
          recedate       : alllist[i]['recedate'],
          recetime        : alllist[i]['recetime'],
          pernm        : alllist[i]['pernm'],
          greginm     : alllist[i]['greginm'],
          reginm     : alllist[i]['reginm'],
          remonm     : alllist[i]['remonm'],
          remoremark : alllist[i]['remoremark']

        );
        setState(() {
          e411Data.add(emObject);
        });

      }
      return e411Data;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: GlobalStyle.appBarIconThemeColor,
          ),
          elevation: GlobalStyle.appBarElevation,
          title: Text(
            '고장내용별 현황' + e411Datas.length.toString(),
            style: GlobalStyle.appBarTitle,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(onPressed: (){

                setState(() {
                  chk = true;

                  e411list_getdata();
                });
                /*searchBook(_etSearch.text);*/
                /*searchBook2(_etSearch2.text);*/
              }, child: Text('검색하기')),
            )
            /*IconButton(onPressed: (){
              print('검색');
            }, icon: Icon(Icons.search))*/
          ],
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,

        ),
        body:

        WillPopScope(
          onWillPop: (){
            Navigator.pop(context);
            return Future.value(true);
          },
          child: Column(
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
                  controller: _etSearch,
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),

                  /*onChanged: searchBook,*/
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
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                height: kToolbarHeight,
                child: TextFormField(
                  controller: _etSearch2,
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                 // onChanged: searchBook2,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[100],
                    filled: true,
                    hintText: '고장내용',
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
                        borderSide: BorderSide(color: Colors.grey[200]!)),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                ),

              ),
            chk ? Expanded(

                  child: ListView.builder(itemCount: e411Datas.length,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index){
                      return _buildListCard(e411Datas[index]);
                    },
                  ),
            ) : Text("현장조회를 하십시오."),

            ],
          ),

        )

    );

  }


  void searchBook(String query){
    final suggestions = e411Data.where((data) {
      final bookTitle = data.actnm.toString();
      final input = query.toString();
      return bookTitle.contains(input);
    }).toList();

    setState(() => e411Datas = suggestions);
  }

  /*void searchBook2(String query){
    final suggestions = e411Data.where((data) {
      final greginmtitle = data.greginm.toString();
      final input = query.toString();
      return greginmtitle.contains(input);
    }).toList();

    setState(() => e411Datas = suggestions);
  }*/





  Widget _buildListCard(e411list_model e411Data){
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager07Detail(e411Data: e411Data)));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e411Data.actnm, style: GlobalStyle.couponName),
              Text('[' + e411Data.contnm + '] ' + e411Data.contents, style: GlobalStyle.couponName),
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
                      Text('처리일자  '+e411Data.compdate+' ', style: GlobalStyle.couponExpired),
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
          title: Text('고장내용조회'),
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

