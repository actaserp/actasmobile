import 'dart:convert';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app03/MhmanualList_model.dart';
import 'package:actasm/ui/account/payment_method/add_payment_method.dart';
import 'package:actasm/ui/account/payment_method/edit_payment_method.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;



import '../tab_home.dart';
import 'appPage03_Edetail.dart';
import 'appPage03_detail.dart';

class AppPage03 extends StatefulWidget {
  @override
  _AppPage03State createState() => _AppPage03State();
}

class _AppPage03State extends State<AppPage03> {
  // 이게뭔지모름
  TextEditingController _etSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _etSearch.dispose();
    super.dispose();
  }

  Future mhlist_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/mhlist';
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
      MhData.clear();
      for (int i = 0; i < alllist.length; i++) {
        MhmanualList_model emObject= MhmanualList_model(
            custcd:alllist[i]['custcd'],
            spjangcd:alllist[i]['spjangcd'],
            remark:alllist[i]['remark'],
            hseq:alllist[i]['hseq'],
            hinputdate:alllist[i]['hinputdate'],
            hgroupcd:alllist[i]['hgroupcd'],
            hsubject:alllist[i]['hsubject'],
            hfilename:alllist[i]['hfilename'],
            hpernm:alllist[i]['hpernm'],
            hmemo:alllist[i]['hmemo'],
            hflag:alllist[i]['hflag'],
            yyyymm:alllist[i]['yyyymm'],
            cnam:alllist[i]['cnam'],
            attcnt:alllist[i]['attcnt']
        );
        setState(() {
          MhData.add(emObject);
        });

      }
      return MhData;
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
            '수리노하우',
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          // bottom: _reusableWidget.bottomAppBar(),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('수리 노하우 자료실', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
            )),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
           child: Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xffcccccc),
                    width: 1.0,
                ),
              ),
              ),

             child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(label: Text('번호',   style: TextStyle(fontWeight: FontWeight.bold,  color: CHARCOAL))),
                      DataColumn(label: Text('분류',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('제목',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('작성자',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('첨부파일건수', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('등록일자', style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('수정/삭제', style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                      // textAlign: TextAlign.center,
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                           DataCell(
                               Row(
                               children: [
                                  Container(
                                  margin: EdgeInsets.only(right: 5),
                                  ),
                                 Text('4392')
                        ],
                   )
                ),
                        DataCell(Text("분류", textAlign: TextAlign.center)),
                        DataCell(Text("제목")),
                          DataCell(Text("admin")),
                          DataCell(Text("1건", textAlign: TextAlign.center,)),
                          DataCell(Text("04/2023")),

                          DataCell(
                          Row(
                             children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EAppPage03Detail()));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                      decoration: BoxDecoration(
                                      color: SOFT_BLUE,
                                      borderRadius: BorderRadius.circular(2)
                                      ),

                                      child: Text('Edit', style: TextStyle(
                                          color: Colors.white
                                      ),
                                      ),
                                ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: GestureDetector(
                                    onTap: (){
                                      _showPopupDeletePayment(1);
                                    },
                                    child: Text('Delete', style: TextStyle(
                                        color: SOFT_BLUE
                                    )),
                                  ),
                                )
                              ],
                            )
                        ),
                      ],
                    ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5)
                                  ),
                                  Text("dd")
                                ],
                            )
                        ),
                        DataCell(Text("Robert Steven")),
                        DataCell(
                            Row(
                              children:[
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => pageDetail()));
                                  },
                                  child: Text('제목조회', style: TextStyle(
                                      fontWeight: FontWeight.bold, color: SOFT_BLUE
                                  )),
                                ),   
                            ],
                           )),
                          DataCell(Text("04/2023")),
                          DataCell(
                              Row(
                                children:[
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => attatchDetail()));
                                    },
                                    child: Text('건수조회', style: TextStyle(
                                        fontWeight: FontWeight.bold, color: SOFT_BLUE
                                    )),
                                  ),
                                ],
                              )),
                          DataCell(Text("04/2023")),

                          DataCell(
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EAppPage03Detail()));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5),
                                    padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                    decoration: BoxDecoration(
                                        color: SOFT_BLUE,
                                        borderRadius: BorderRadius.circular(2)
                                    ),

                                    child: Text('Edit', style: TextStyle(
                                        color: Colors.white
                                    ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: GestureDetector(
                                    onTap: (){
                                      _showPopupDeletePayment(2);
                                    },
                                    child: Text('Delete', style: TextStyle(
                                        color: SOFT_BLUE
                                    )),
                                  ),
                                )
                              ],
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),


            Container( //노하우등록임
              margin: EdgeInsets.only(top: 32),
              child: OutlinedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage03Detail(MhData: MhData, MhData: null,)));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage03Detail()));

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
                  ), //등록 스타일
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      '노하우 등록',
                      style: TextStyle(
                          color: SOFT_BLUE,
                          fontWeight: FontWeight.bold,
                          fontSize: 13
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
              ),
            )
      ],
        ),
        );
  }

  void showPopupMakeDefault() {
    // set up the buttons
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('No', style: TextStyle(color: SOFT_BLUE))
    );
    Widget continueButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
          // _reusableWidget.startLoading(context, 'Success', 0);
        },
        child: Text('Yes', style: TextStyle(color: SOFT_BLUE))
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('Make Default', style: TextStyle(fontSize: 18),),
      content: Text('Are you sure to make this card as a default payment ?', style: TextStyle(fontSize: 13, color: BLACK_GREY)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showPopupDeletePayment(int index) {
    // set up the buttons
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('No', style: TextStyle(color: SOFT_BLUE))
    );
    Widget continueButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
          if(index==0){
            Fluttertoast.showToast(msg: 'Please change default payment method if you want to delete this payment method', toastLength: Toast.LENGTH_LONG);
          } else {
            // _reusableWidget.startLoading(context, 'Delete Payment Method Success', 0);
          }
        },
        child: Text('Yes', style: TextStyle(color: SOFT_BLUE))
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('Delete Payment Method', style: TextStyle(fontSize: 18),),
      content: Text('Are you sure to delete this payment method ?', style: TextStyle(fontSize: 13, color: BLACK_GREY)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}


//03 조회
Widget pageDetail(){
  return Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(
        color: GlobalStyle.appBarIconThemeColor,
      ),
      elevation: GlobalStyle.appBarElevation,
      title: Text(
        '수리노하우',
        style: GlobalStyle.appBarTitle,
      ),
      backgroundColor: GlobalStyle.appBarBackgroundColor,
      systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      // bottom: _reusableWidget.bottomAppBar(),
    ),
  body: ListView(
  padding: EdgeInsets.all(16),
    children: [
      Text('분류분류분류분류', style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: SOFT_BLUE
      )),
      Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xffcccccc),
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text('글제목글제목글제목', style: TextStyle(
                  fontSize:14, fontWeight: FontWeight.bold, color: CHARCOAL
              )),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text('작성자', style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: SOFT_BLUE
                  ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Text('글내용글내용글내용', style: TextStyle(
                  fontSize:14, fontWeight: FontWeight.bold, color: CHARCOAL
              )),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text('글내용글내용글내용2', style: TextStyle(
                  fontSize: 14, color: CHARCOAL
              )),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Text('첨부파일리스트', style: TextStyle(
                  fontSize:14, fontWeight: FontWeight.bold, color: CHARCOAL
              )),
            ),
            SizedBox(
              height: 12,
            ),
            _buildFileList(),
          ],
        ),
      ),
      SizedBox(
        height: 32,
      ),
    ],
  ),
      );
}


//첨부파일만 조회
Widget attatchDetail(){
  return Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(
        color: GlobalStyle.appBarIconThemeColor,
      ),
      elevation: GlobalStyle.appBarElevation,
      title: Text(
        '수리노하우',
        style: GlobalStyle.appBarTitle,
      ),
      backgroundColor: GlobalStyle.appBarBackgroundColor,
      systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      // bottom: _reusableWidget.bottomAppBar(),
    ),
    body: ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text('분류분류분류분류', style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700, color: SOFT_BLUE
        )),
        Container(
          margin: EdgeInsets.only(top:8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffcccccc),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top:8),
                child: Text('글제목', style: TextStyle(
                    fontSize:14, fontWeight: FontWeight.bold, color: CHARCOAL
                )),
              ),
              SizedBox(
                height: 12,
              ),
              _buildFileList(),
            ],
          ),
        ),
        SizedBox(
          height: 32,
        ),
      ],
    ),
  );
}

//첨부파일리스트
Widget _buildFileList(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(

        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Text('첨부파일리스트자리입니다.', style:
                TextStyle(
                    color: BLACK_GREY,
                    fontWeight: FontWeight.bold,
                    fontSize: 13
                ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ], //row-childeren
          // children: List.generate(shoppingCartData.length,(index){
          // return _buildItem(index, boxImageSize);
          // }),
        ),
      )
    ],
  );
}