import 'dart:convert';

import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app02/tbe401list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import 'appPager12Detail.dart';

class AppPager12 extends StatefulWidget {
  @override
  _AppPager12State createState() => _AppPager12State();
}

class _AppPager12State extends State<AppPager12>{
  TextEditingController _etSearch = TextEditingController();
  TextEditingController _etSearch2 = TextEditingController();
  List<tbe401list_model> tbe401Datas = tbe401Data;



  @override
  void initState() {
    // TODO: implement initState
    e401list_getdate();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tbe401Data.clear();
  }


  Future e401list_getdate() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/tbe401list';
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
        'equpnm': _etSearch2.text,


      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      tbe401Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        tbe401list_model emObject= tbe401list_model(
            recedate    : alllist[i]['recedate'],
            compdate    : alllist[i]['compdate'],
            actnm    : alllist[i]['actnm'],
            equpnm    : alllist[i]['equpnm'],
            hitchdate    : alllist[i]['hitchdate'],
            indate    : alllist[i]['indate'],
            contnm    : alllist[i]['contnm'],
            contents    : alllist[i]['contents'],
            greginm    : alllist[i]['greginm'],
            reginm    : alllist[i]['reginm'],
            remonm    : alllist[i]['remonm'],
            remoremark    : alllist[i]['remoremark'],
            resunm    : alllist[i]['resunm']

        );
        setState(() {
          tbe401Data.add(emObject);
        });

      }
      return tbe401Data;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text(
          '고장이력 ' + tbe401Data.length.toString() + '건',
          style: GlobalStyle.appBarTitle,
        ),

        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(onPressed: (){

              setState(() {

                e401list_getdate();

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
      WillPopScope(onWillPop: (){
        Navigator.pop(context);
        return Future.value(true);
      }, child: Column(
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
                hintText: '동호기명',
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
          Expanded(

            child: ListView.builder(itemCount: tbe401Datas.length,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return _buildListCard(tbe401Datas[index]);
              },
            ),
          )
        ],
      )),
    );
  }

  Widget _buildListCard(tbe401list_model tbe401Data){
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager12Detail(tbe401Data: tbe401Data)));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tbe401Data.actnm, style: GlobalStyle.couponName),
              Text('[' + tbe401Data.contnm + '] ' + tbe401Data.contents, style: GlobalStyle.couponName),
              Text(tbe401Data.equpnm, style: GlobalStyle.couponName),

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
                      Text('접수일자  '+tbe401Data.recedate+' ', style: GlobalStyle.couponExpired),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      // Fluttertoast.showToast(msg: 'Coupon applied', toastLength: Toast.LENGTH_LONG);
                      Navigator.pop(context);
                    },
                    child: Text('처리일자  ' +tbe401Data.compdate, style: TextStyle(
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