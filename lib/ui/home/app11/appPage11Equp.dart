import 'dart:convert';

import 'package:actasm/ui/home/app5Home/appPager15register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/tbe601list_model.dart';
import '../../../model/app04/tbe611list_model.dart';

class AppPage11Equp extends StatefulWidget {

  final String data;

  AppPage11Equp({required this.data});

  @override
  _AppPage11EqupState createState() => _AppPage11EqupState();
}


class _AppPage11EqupState extends State<AppPage11Equp> {

 String _searchTerm = '';

 List<tbe611list_model> e611Datas = E611Data;

 @override
  void initState() {
    // TODO: implement initState
   super.initState();
   _searchTerm = widget.data;
   getequpinfo();

  }

 Future getequpinfo() async {
   String _dbnm = await SessionManager().get("dbnm");

   var uritxt = CLOUD_URL + '/e038mbc/getEqupInfo';
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
       'actcd': _searchTerm,


     },
   );
   if(response.statusCode == 200){

     List<dynamic> alllist = [];
     alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
     E611Data.clear();
     for (int i = 0; i < alllist.length; i++) {
       tbe611list_model emObject= tbe611list_model(

           /*actaddr  : alllist[i]["actaddr"],*/
           actnm:    alllist[i]["actnm"],
           cltcd:    alllist[i]['cltcd'],
           equpnm:   alllist[i]['equpnm'],
           equpcd:   alllist[i]['equpcd'],
           custcd:   alllist[i]['custcd'],
           spjangcd: alllist[i]['spjangcd']

       );
       setState(() {
         E611Data.add(emObject);
       });


     }
     return E611Data;
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
    '호기 조회' ,
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
    return _buildListCard(E611Data[index]);
    }
    ),
    ));
  }


 Widget _buildListCard(tbe611list_model E611Data){
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
             TextButton(child: Text(E611Data.equpnm, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                 onPressed: () {

                   Navigator.pop(context, [E611Data.equpcd, E611Data.equpnm]);
                 },
               ),
             Text('호기코드: ' + E611Data.equpcd, style: GlobalStyle.couponName),
             // Text(e401Data.contents, style: GlobalStyle.couponName),
             SizedBox(height: 12),
           ],
         ),
       ),
     ),
   );
 }




}
