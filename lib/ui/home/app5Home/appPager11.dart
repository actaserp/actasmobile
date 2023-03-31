

import 'dart:convert';

import 'package:actasm/config/global_style.dart';
import 'package:actasm/config/constant.dart';
import 'package:actasm/model/app02/books.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../../model/app02/e411list_model.dart';
import '../../../model/app02/tbe601list_model.dart';
import 'appPager07_detail.dart';
import 'appPager11Detail.dart';


class AppPager11 extends StatefulWidget {
  @override
  _AppPager11State createState() => _AppPager11State();
}

class _AppPager11State extends State<AppPager11> {
  TextEditingController _etSearch = TextEditingController();
  TextEditingController _etSearch2 = TextEditingController();

  List<tbe601list_model> e601Datas = e601Data;
  bool chk = false;


  List<String> elvlrt = [];
  String addres='';
  String buldNm='';
  String installationPlace='';
  String elvtrDivNm = '';
  String elvtrKindNm = '';
  String frstInstallationDe = "";
  String sigunguNm = '';




  @override
  void initState(){
    super.initState();
    e601list_getdata();


  }

  @override
  void dispose(){
    _etSearch.dispose();
    e601Data.clear();
    super.dispose();
  }

  Future e601list_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/tbe601list';
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


      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      e601Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        tbe601list_model emObject= tbe601list_model(

          elno:      alllist[i]["elno"],
          equpnm:    alllist[i]["equpnm"],
          actnm :    alllist[i]["actnm"],
          actaddr  : alllist[i]["actaddr"],
          tel:       alllist[i]["tel"],
          hp:         alllist[i]["hp"],
          pernm:    alllist[i]["pernm"],
          emtelnum:  alllist[i]["emtelnum"],

        );
        setState(() {
          e601Data.add(emObject);
        });

      }
      return e601Data;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }
///////////////////////////////////////////////////////////////////////////////////////////////////

  Future getelvinfo() async {

    var uritxt = CLOUD_URL + '/apppgymobile/getelvinfo_1';
    var encoded = Uri.encodeFull(uritxt);

    Uri uri = Uri.parse(encoded);
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {

        'elvnum': _etSearch2.text,


      },
    );
    if(response.statusCode == 200){

      var addr2 = utf8.decode(response.bodyBytes);
      Map<String, dynamic> user = jsonDecode(addr2);



      addres =  user['response']['body']['items']['item'][0]['address1'];
      buldNm = user['response']['body']['items']['item'][0]['buldNm'];
      installationPlace = user['response']['body']['items']['item'][0]['installationPlace'];
      elvtrDivNm = user['response']['body']['items']['item'][0]['elvtrDivNm'];
      elvtrKindNm =  user['response']['body']['items']['item'][0]['elvtrKindNm'];
      frstInstallationDe = user['response']['body']['items']['item'][0]['frstInstallationDe'];
      sigunguNm = user['response']['body']['items']['item'][0]['sigunguNm'];
      elvlrt.add(addres);
      elvlrt.add(buldNm);
      elvlrt.add(installationPlace);
      elvlrt.add(elvtrDivNm);
      elvlrt.add(elvtrKindNm);
      elvlrt.add(frstInstallationDe);
      elvlrt.add(sigunguNm);


    }
    else{
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text('서버 통신 실패, 관리자 문의 요망'),
        );
      });
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
            '보수현장조회 ' + e601Datas.length.toString(),
            style: GlobalStyle.appBarTitle,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(onPressed: (){

                setState(() {

                  e601list_getdata();



                });
                /*searchBook(_etSearch.text);*/
                /*searchBook2(_etSearch2.text);*/
              }, child: Text('검색하기')),
            )
            /*IconButton(onPressed: (){

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
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.636 ,
                      child: TextField(
                        controller: _etSearch2,
                        textAlignVertical: TextAlignVertical.bottom,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),

                        /*onChanged: searchBook,*/
                        decoration: InputDecoration(
                          fillColor: Colors.grey[300],
                          filled: true,
                          hintText: '승강기번호를 입력하세요',
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
                              borderSide: BorderSide(color: Colors.blue[800]!)),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: ElevatedButton(
                        onPressed: () async {

                         /* getelvinfo();


                          Future.delayed(Duration(milliseconds: 1200), (){
                            if(elvlrt.length == 0){
                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  content: Text('유효하지 않습니다.'),
                                );
                              });
                            }
                            showAlertDialog(context, elvlrt[0], elvlrt[1], elvlrt[2], elvlrt[3], elvlrt[4], elvlrt[5], elvlrt[6]);
                          });*/
                          await getelvinfo();
                          if(elvlrt.length == 0){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                content: Text('유효하지 않습니다.'),
                              );
                            });
                          }
                          showAlertDialog(context, elvlrt[0], elvlrt[1], elvlrt[2], elvlrt[3], elvlrt[4], elvlrt[5], elvlrt[6]);


                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width/9,
                            child: Center(child: Text('조회'+ '\n' +'하기'))),
                      ),
                    )
                  ],
                ),

              ),

              Expanded(

                child: ListView.builder(itemCount: e601Datas.length,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index){
                    return _buildListCard(e601Datas[index]);
                  },
                ),
              ),

            ],
          ),

        )

    );

  }


  /*void searchBook(String query){
    final suggestions = e411Data.where((data) {
      final bookTitle = data.actnm.toString();
      final input = query.toString();
      return bookTitle.contains(input);
    }).toList();

    setState(() => e411Datas = suggestions);
  }*/

  /*void searchBook2(String query){
    final suggestions = e411Data.where((data) {
      final greginmtitle = data.greginm.toString();
      final input = query.toString();
      return greginmtitle.contains(input);
    }).toList();

    setState(() => e411Datas = suggestions);
  }*/





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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager11Detail(e601Data: e601Data)));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e601Data.actnm, style: GlobalStyle.couponName),
              Text(e601Data.actaddr, style: GlobalStyle.couponName),

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
                      Text('호기명  '+e601Data.equpnm+' ', style: GlobalStyle.couponExpired),


                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      // Fluttertoast.showToast(msg: 'Coupon applied', toastLength: Toast.LENGTH_LONG);

                    },
                    child: Text(e601Data.pernm, style: TextStyle(
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

  void showAlertDialog(BuildContext context, String as_msg, String as_addr, String installationplace, String elvtrDivNm, String elvtrKindNm,
      String frstInstallationDe, String sigunguNm) async {



    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(as_addr + installationplace),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(as_msg, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold), softWrap: true,),
                  SizedBox(
                    height: 20,
                  ),
                  Text(elvtrDivNm),
                  SizedBox(
                    height: 20,
                  ),
                  Text(elvtrKindNm),
                  SizedBox(
                    height: 20,
                  ),
                  Text(frstInstallationDe),
                  SizedBox(
                    height: 20,
                  ),
                  Text(sigunguNm),

                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                elvlrt.clear();
                Navigator.pop(context, "확인");

              },
            ),
          ],
        );
      },
    );
  }


}

