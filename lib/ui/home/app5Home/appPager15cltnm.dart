import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/cltnmlist_model.dart';

class AppPager15Cltnm extends StatefulWidget {

  final String data;

  AppPager15Cltnm({required this.data});

  @override
  _AppPager15CltnmState createState() => _AppPager15CltnmState();
}


class _AppPager15CltnmState extends State<AppPager15Cltnm> {

  String _searchTerm = '';

  List<cltnmlist_model> cltnmDatas = cltnmData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchTerm = widget.data;
    getcltnminfo();
    print(_searchTerm);
  }




  Future getcltnminfo() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/apppgymobile/cltnmlist';
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
        'cltnm': _searchTerm,


      },
    );
    if(response.statusCode == 200){

      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      cltnmData.clear();
      for (int i = 0; i < alllist.length; i++) {
        cltnmlist_model emObject= cltnmlist_model(

          cltcd: alllist[i]["cltcd"],
          cltnm: alllist[i]["cltnm"],
          saupnum: alllist[i]["saupnum"],
          prenm: alllist[i]["prenm"],
        );
        setState(() {
          cltnmData.add(emObject);
        });

      }
      return cltnmData;
    }else{
      throw Exception('불러오는데 실패했습니다.');
    }
  }


  Widget build(BuildContext context){
    return Scaffold(
     appBar: AppBar(
       iconTheme: IconThemeData(
         color: GlobalStyle.appBarIconThemeColor,
       ),
       elevation: GlobalStyle.appBarElevation,
       title: Text(
         '사업장 조회' ,
         style: GlobalStyle.appBarTitle,
       ),
       backgroundColor: GlobalStyle.appBarBackgroundColor,
       systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
     ),
      body: WillPopScope(
        onWillPop: (){
          Navigator.pop(context);
          return Future.value(true);
        },
        child: ListView.builder(itemCount: cltnmData.length,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder:  (BuildContext context, int index){
              return _buildListCard(cltnmData[index]);
            }
        ),
      ),
    );
  }

  Widget _buildListCard(cltnmlist_model cltnmData){
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
          /*Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage02Detail(e401Data: e401Data)));*/
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(child: Text(cltnmData.cltnm, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                onPressed: () {
                  print(cltnmData.cltcd);
                  Navigator.pop(context, [cltnmData.cltcd, cltnmData.cltnm]);
                },
              ),
              Text('현장코드: ' + cltnmData.cltcd, style: GlobalStyle.couponName),
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
                      Text('사업자번호: '+cltnmData.saupnum, style: GlobalStyle.couponExpired),
                    ],
                  ),
                ],
              ),
              Text('담당자: ' + cltnmData.prenm)
            ],
          ),
        ),
      ),
    );
  }

}