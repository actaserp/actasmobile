import 'dart:convert';

import 'package:actasm/ui/home/app5Home/appPager15register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/tbe601list_model.dart';
import '../../../model/app04/tbe047list_model.dart';
import '../../../model/app04/tbe611list_model.dart';

class AppPage11Car extends StatefulWidget {

  final String data;

  AppPage11Car({required this.data});

  @override
  _AppPage11CarState createState() => _AppPage11CarState();
}


class _AppPage11CarState extends State<AppPage11Car> {

 String _searchTerm = '';

 List<tbe047list_model> e047Datas = E047Data;

 @override
  void initState() {
    // TODO: implement initState
   super.initState();
   _searchTerm = widget.data;
   getcarinfo();

  }

 Future getcarinfo() async {
   String _dbnm = await SessionManager().get("dbnm");

   var uritxt = CLOUD_URL + '/e038mbc/getCarInfo';
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
       'carnum': _searchTerm,


     },
   );
   if(response.statusCode == 200){

     List<dynamic> alllist = [];
     alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
     E047Data.clear();
     for (int i = 0; i < alllist.length; i++) {
       tbe047list_model emObject= tbe047list_model(

           /*actaddr  : alllist[i]["actaddr"],*/
           custcd:   alllist[i]['custcd'],
           spjangcd: alllist[i]['spjangcd'],
           carcd:    alllist[i]['carcd'],
           carnum:   alllist[i]['carnum'],
           pernm:    alllist[i]['pernm']

       );
       setState(() {
         E047Data.add(emObject);
       });


     }
     return E047Data;
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
    '차량 조회' ,
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
    return _buildListCard(E047Data[index]);
    }
    ),
    ));
  }


 Widget _buildListCard(tbe047list_model E047Data){
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
             TextButton(child: Text(E047Data.carnum, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                 onPressed: () {

                   Navigator.pop(context, [E047Data.carcd, E047Data.carnum]);
                 },
               ),
             Text('차량코드: ' + E047Data.carcd + ', 차량담당자: ' + E047Data.pernm, style: GlobalStyle.couponName),
             // Text(e401Data.contents, style: GlobalStyle.couponName),
             SizedBox(height: 12),
           ],
         ),
       ),
     ),
   );
 }




}
