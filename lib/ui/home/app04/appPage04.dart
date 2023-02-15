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



import '../../../model/app04/BmanualList_model.dart';
import 'appPage04_detail.dart';
import 'appPage04_view.dart';

class AppPage04 extends StatefulWidget {

  @override
  _AppPage04State createState() => _AppPage04State();
}

class _AppPage04State extends State<AppPage04> {

  List<DataRow> _dataGrid(BmanualList_model BData) {
    debugPrint('The value of a is $_dataGrid(BData)');
    return [
      DataRow(
        cells: <DataCell>[
          DataCell(
            ConstrainedBox(
                constraints: BoxConstraints(minWidth: 75, maxWidth: 75), //SET max width
                child: Text('${BData.bseq}',
                    overflow: TextOverflow.ellipsis)),
          ),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 55, minWidth: 50), //SET max width
                    child: Text('${BData.bgourpcd}',
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage04view(BData: BData)));
                    },
                    child: ConstrainedBox(
                      constraints:  BoxConstraints(minWidth: 180 , maxWidth: 180),
                      child: Text('${BData.bsubject}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: SOFT_BLUE, fontSize: 12, fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                  ),
                ],
              )
          ),
          DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 50), //SET max width
                      child: Text('${BData.bpernm}',
                          overflow: TextOverflow.ellipsis)),
                ],
              )
          ),
          DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // margin: EdgeInsets.only(right: 5),
                  ),
                  Text('${BData.binputdate}')
                ],
              )
          ),
        ],
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    blist_getdata();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future blist_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/Blist';
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
        BmanualList_model BObject= BmanualList_model(
            custcd:alllist[i]['custcd'],
            spjangcd:alllist[i]['spjangcd'],
          bseq:alllist[i]['bseq'],
          binputdate:alllist[i]['binputdate'],
          bgourpcd:alllist[i]['bgourpcd'],
          bsubject:alllist[i]['bsubject'],
          bpernm:alllist[i]['bpernm'],
          bmemo:alllist[i]['bmemo'],
          bflag:alllist[i]['bflag'],
        );
        setState(() {
          BData.add(BObject);
        });

      }
      return BData;
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
            '부품 가이드',
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          // bottom: _reusableWidget.bottomAppBar(),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('부품 가이드 자료실', style: TextStyle(
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
             height: 700,
             width: 750,
             child: ListView.builder( //hassize is not true ~~~~~~~~~~~~~~~~~~~~~~~~~~~굿~~~
               shrinkWrap: true,
               itemCount: BData.length,
               // physics: NeverScrollableScrollPhysics(),
               itemBuilder: (BuildContext context, int index) {
                 return DataTable (
                   columnSpacing: 10,
                   dataRowHeight: 40,
                   columns:
                   <DataColumn>[
                     DataColumn(label:
                      Text('번호',
                         style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL),
                     )),
                     DataColumn(label: Text('분류',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                     DataColumn(label: Text('제목',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                     DataColumn(label: Text('작성자',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                     DataColumn(label: Text('등록일자', style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                   ], rows:
                 _dataGrid(BData[index]),
                 );
               },
             ),
           ),  //listview.builder endpoint
        ),
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xffcccccc),
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Container( //등록임
              margin: EdgeInsets.only(top: 10),
              child: OutlinedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage03Detail(MhData: MhData, MhData: null,)));
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => AppPage04Detail()));
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
                  ),
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
