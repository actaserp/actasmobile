import 'dart:convert';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app03/MhmanualList_model.dart';
import 'package:actasm/ui/account/payment_method/add_payment_method.dart';
import 'package:actasm/ui/account/payment_method/edit_payment_method.dart';
import 'package:actasm/ui/home/app03/Nav_right.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;



import '../../../model/app04/BmanualList_model.dart';
import '../appPage02.dart';
import '../tab_home.dart';
import 'appPage04_detail.dart';
import 'appPage04_view.dart';

class AppPage04 extends StatefulWidget {

  @override
  _AppPage04State createState() => _AppPage04State();
}

class _AppPage04State extends State<AppPage04> {
  TextEditingController _etSearch = TextEditingController();
  late String _dbnm;

  @override
  void initState() {
    super.initState();
    blist_getdata();
  }

  @override
  void dispose() {
    _etSearch.dispose();
    super.dispose();
  }

  Future blist_getdata() async {
    _dbnm = await  SessionManager().get("dbnm");
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
      ///clear 안 해주면 length 조절 안됨
      BData.clear();
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
          attcnt:alllist[i]['attcnt']
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
      endDrawer: Nav_right(
        text: Text('app04_nav'),
        color: SOFT_BLUE,
      ),
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
                  setState(() {});
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  hintText: '제목/내용 검색',
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
            preferredSize: Size.fromHeight(kToolbarHeight),
          ),
        ),
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              padding: EdgeInsets.only(top:16, bottom: 2, left: 10),
              child: Text('부품 가이드 자료실  ${BData.length} 건', style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
              )),
            ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
           child: Container(
              margin: EdgeInsets.only(top: 15),
             height: 700,
             width: 900,
             child: ListView(
               scrollDirection: Axis.vertical,
                 children: [ DataTable (
                   showCheckboxColumn: false,
                   columnSpacing: 25, dataRowHeight: 40,
                   headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                   headingRowColor:
                   MaterialStateColor.resolveWith((states) => SOFT_BLUE),
                   columns:
                   <DataColumn>[
                     DataColumn(label: Text('No.')),
                     DataColumn(label: Text('분류')),
                     DataColumn(label: Text('제목')),
                     DataColumn(label: Text('내용')),
                     DataColumn(label: Text('작성자')),
                     DataColumn(label: Text('첨부파일건수')),
                     DataColumn(label: Text('작성일자')),
                   ], rows:
                      List<DataRow>.generate(BData.length, (index)
                      {
                      final BmanualList_model item = BData[index];
                      return
                              DataRow(
                              onSelectChanged: (value){
                              Navigator.push(context, MaterialPageRoute(
                              builder: (context) => AppPage04view(BData: item)));
                              },
                              color: MaterialStateColor.resolveWith((states){
                              if (index % 2 == 0){
                              return Color(0xB8E5E5E5);
                              }else{
                              return Color(0x86FFFFFF);
                              }
                              }),
                              cells: [
                                DataCell(
                                    ConstrainedBox(
                                        constraints: BoxConstraints(minWidth: 50, maxWidth: 53),
                                        child: Text('${index+1}',
                                        ))),
                              DataCell(
                              ConstrainedBox(
                              constraints: BoxConstraints(minWidth: 50, maxWidth: 53),
                                  child: Text(item.bgourpcd,
                                  ))),
                              DataCell(Container(
                              width: 180,
                                  child: Text(item.bsubject,
                                  overflow: TextOverflow.ellipsis),
                                  )),
                              DataCell(Container(
                              width:180,
                                  child: Text(item.bmemo,
                                  overflow: TextOverflow.ellipsis),
                                  )),
                              DataCell(Text(item.bpernm,
                              overflow: TextOverflow.ellipsis)),
                              DataCell(Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Text(item.attcnt.toString()),
                              ],
                              )),
                              DataCell(
                              Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                      ConstrainedBox(
                                      constraints: BoxConstraints(minWidth: 95, maxWidth: 95),
                                      child: Text('${item.binputdate}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                      color: SOFT_BLUE,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                      )
                                      ),
                                      ),
                              ],
                              )
                              ),
                              ]);
                              }),
                              ),
                              ])),
                              ),
            Container( ///노하우등록
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(12),
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
                      '부품가이드 등록',
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


}
