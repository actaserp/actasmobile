import 'dart:convert';

import 'package:actasm/model/app02/ja001list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../config/constant.dart';
import '../../../config/global_style.dart';



class AppPager10 extends StatefulWidget {
  @override
  _AppPager10State createState() => _AppPager10State();
}


class _AppPager10State extends State<AppPager10> {

  TextEditingController _etSearch = TextEditingController();
  TextEditingController _etSearch2 = TextEditingController();
  List<ja001list_model> ja001Datas = ja001Data;
  bool chk = false;


  @override
  void initState(){
    super.initState();
    ja001list_getdata();

  }

  @override
  void dispose(){
    ja001Data.clear();
    super.dispose();
  }



  Future ja001list_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/ja001list';
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
        'pernm': _etSearch.text,
        'divinm': _etSearch2.text,

      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      ja001Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        ja001list_model emObject= ja001list_model(

            pernm:  alllist[i]['pernm'],
            divinm: alllist[i]['divinm'],
            rspnm:  alllist[i]['rspnm'],
            handphone: alllist[i]['handphone']

        );
        setState(() {
          ja001Data.add(emObject);
        });

      }
      return ja001Data;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }

  }

  @override
  Widget build(BuildContext buildContext){
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: GlobalStyle.appBarIconThemeColor,
          ),
          elevation: GlobalStyle.appBarElevation,
          title: Text(
            '직원리스트' + ja001Datas.length.toString(),
            style: GlobalStyle.appBarTitle,
          ),
          actions: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: TextButton(onPressed: (){

                    setState(() {
                      chk = true;

                      ja001list_getdata();
                    });
                    /*searchBook(_etSearch.text);*/
                    /*searchBook2(_etSearch2.text);*/
                  }, child: Text('검색하기')),
                ),

              ],
            )
          ],
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        ),
        body:
        WillPopScope(onWillPop: (){
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
                    hintText: '사원명',
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
              /*Container(

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
                hintText: '부서명',
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

          ),*/
              chk ? Expanded(

                child: ListView.builder(itemCount: ja001Datas.length,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index){
                    return _buildListCard(ja001Datas[index]);
                  },
                ),
              ) : Text("직원조회를 하십시오."),
            ],
          ),
        )
    );
  }

  Widget _buildListCard(ja001list_model ja001Data){
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
          /*Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager07Detail(e411Data: e411Data)));*/
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ja001Data.pernm, style: GlobalStyle.couponName),
              TextButton(onPressed: () async {
                final url = Uri.parse('tel:' + ja001Data.handphone);
                if (await canLaunchUrl(url)) {
                  launchUrl(url);
                } else {
                  // ignore: avoid_print
                  print("Can't launch $url");
                }
              }, child: Text('[' + ja001Data.divinm + '] ' + ja001Data.handphone + '   전화걸기', style: GlobalStyle.couponName,),),
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
                      Text('직급   '+ja001Data.rspnm+' ', style: GlobalStyle.couponExpired, ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse('sms:' + ja001Data.handphone);
                      if (await canLaunchUrl(url)) {
                        launchUrl(url);
                      } else {
                        // ignore: avoid_print
                        print("Can't launch $url");
                      }
                    },

                    child: Text("문자전송", style: TextStyle(
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
          title: Text('직원정보조회'),
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