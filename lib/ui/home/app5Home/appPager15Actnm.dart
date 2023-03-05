import 'dart:convert';

import 'package:actasm/ui/home/app5Home/appPager15register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/tbe601list_model.dart';

class AppPager15Actnm extends StatefulWidget {

  final String data;

  AppPager15Actnm({required this.data});

  @override
  _AppPager15ActnmState createState() => _AppPager15ActnmState();
}


class _AppPager15ActnmState extends State<AppPager15Actnm> {

 String _searchTerm = '';

 List<tbe601list_model> e601Datas = e601Data;

 @override
  void initState() {
    // TODO: implement initState
   super.initState();
   _searchTerm = widget.data;
   getactnminfo();

  }

 Future getactnminfo() async {
   String _dbnm = await SessionManager().get("dbnm");

   var uritxt = CLOUD_URL + '/apppgymobile/tbe601list';
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
       'actnm': _searchTerm,


     },
   );
   if(response.statusCode == 200){

     List<dynamic> alllist = [];
     alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
     e601Data.clear();
     for (int i = 0; i < alllist.length; i++) {
       tbe601list_model emObject= tbe601list_model(


           actnm :    alllist[i]["actnm"],
           actcd:    alllist[i]["actcd"],
            cltcd:    alllist[i]["cltcd"],

       );
       setState(() {
         e601Data.add(emObject);
       });


     }
     return e601Data;
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
    '현장 조회' ,
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
    child: ListView.builder(itemCount: e601Data.length,
    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
    physics: AlwaysScrollableScrollPhysics(),
    itemBuilder:  (BuildContext context, int index){
    return _buildListCard(e601Data[index]);
    }
    ),
    ));
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
         /*Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage02Detail(e401Data: e401Data)));*/
       },
       child: Container(
         padding: EdgeInsets.all(16),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             TextButton(child: Text(e601Data.actnm, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                 onPressed: () {

                   Navigator.pop(context, [e601Data.actcd, e601Data.actnm, e601Data.cltcd]);
                 },
               ),
             Text('현장코드: ' + e601Data.actcd, style: GlobalStyle.couponName),
             // Text(e401Data.contents, style: GlobalStyle.couponName),
             SizedBox(height: 12),

           ],
         ),
       ),
     ),
   );
 }




}
