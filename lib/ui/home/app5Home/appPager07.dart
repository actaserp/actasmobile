

import 'dart:convert';

import 'package:actasm/config/global_style.dart';
import 'package:actasm/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../../model/app02/e411list_model.dart';


class AppPager07 extends StatefulWidget {
  @override
  _AppPager07State createState() => _AppPager07State();
}

class _AppPager07State extends State<AppPager07> {
  TextEditingController _etSearch = TextEditingController();


  @override
  void initState(){
    super.initState();
    e411list_getdata();

  }

  @override
  void dispose(){
    _etSearch.dispose();
    super.dispose();
  }
/*
  Future e411list_getdata() async{
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/e411list';
    var encoded = Uri.encodeFull(uritxt);

    Uri uri = Uri.parse(encoded);
    final response = http.post(
      uri,
      headers: <String, String> {
        'Content-Type' : 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm' : _dbnm,
      },
    );


    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist = jsonDecode(utf8.decode(response.bodyBytes));
      e411Data.clear();
      for()


      return e411Data;

    }
  }*/
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
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      e411Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        e411list_model emObject= e411list_model(
          compyear     :alllist[i]['remark'],
          actnm     :alllist[i]['contents'],
          equpcd    :alllist[i]['actperid'],
          equpnm     :alllist[i]['perid'],
          greginm     :alllist[i]['frdate'],
          gregicd     :alllist[i]['todate'],
          reginm     :alllist[i]['recedate'],
          result     :alllist[i]['recenum'],
          mon01     :alllist[i]['actcd'],
          mon02     :alllist[i]['actnm'],
          mon03     :alllist[i]['equpcd'],
          mon04     :alllist[i]['equpnm'],
          mon05     :alllist[i]['actpernm'],
          mon06     :alllist[i]['pernm'],
          mon07     :alllist[i]['contcd'],
          mon08     :alllist[i]['contnm'],
          mon09     :alllist[i]['contremark'] ,
          mon10     :alllist[i]['recetime'],
          mon11     :alllist[i]['compdate'],
          mon12     :alllist[i]['comptime'],
          frdate     :alllist[i]['resuremark'],
          todate     :alllist[i]['resultcd'],

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
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: GlobalStyle.appBarIconThemeColor,
          ),
          elevation: GlobalStyle.appBarElevation,
          title: Text(
            '고장부위별 현황' + e411Data.length.toString(),
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          bottom: PreferredSize(
            child: Container(
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
                  setState(() {

                  },);
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled:  true,
                  hintText: '보수현장명',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  suffixIcon: (_etSearch.text == '')
                      ? null : GestureDetector(
                      onTap: (){
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
            preferredSize: Size.fromHeight(kToolbarHeight),
          ),
        ),
        body: WillPopScope(
          onWillPop: (){
            Navigator.pop(context);
            return Future.value(true);
          },
          child: ListView.builder(itemCount: e411Data.length,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index){
              return _buildListCard(e411Data[index]);
            },
          ),
        ));
  }


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
          /*Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage07Detail(e411Data: e411Data)));
          */
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e411Data.actnm, style: GlobalStyle.couponName),
              Text('['+ e411Data.greginm + ']' + e411Data.reginm, style: GlobalStyle.couponName),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GlobalStyle.iconTime,
                      SizedBox(width: 4,
                      ),
                      Text('접수일자 ' + e411Data.compyear , style: GlobalStyle.couponExpired),

                    ],
                  ),

                ],
              )
            ],
          ),
        ),
      ),

    );
  }
}