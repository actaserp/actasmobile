import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/plan_model.dart';
import 'appPager15register.dart';

class AppPager15 extends StatefulWidget {


  @override
  _AppPager15State createState() => _AppPager15State();
}

class _AppPager15State extends State<AppPager15> {

  TextEditingController _etSearch = TextEditingController();

  late final String good;
  late String _dbnm;

  @override
  void initState(){
    super.initState();
    plan_getdata();
  }

  @override
  void dispose(){
    _etSearch.dispose();
    super.dispose();

  }


  Future plan_getdata() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/apppgymobile/planlist';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    // try {
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
      },
      body: <String, String>{
        'dbnm': _dbnm,
        'actcd': '%',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> alllist = [];
      alllist = jsonDecode(utf8.decode(response.bodyBytes));
      planData.clear();
      for (int i = 0; i < alllist.length; i++) {
        plan_model MhObject = plan_model(
          plandate: alllist[i]['plandate'],
          actcd: alllist[i]['actcd'],
          actnm: alllist[i]['actnm'],
          equpcd: alllist[i]['equpcd'],
          equpnm: alllist[i]['equpnm'],
          perid: alllist[i]['perid'],
          pernm: alllist[i]['pernm'],
          remark: alllist[i]['remark'],
          kcpernm: alllist[i]['kcpernm'],
          kcspnm: alllist[i]['kcspnm'],
          indate: alllist[i]['indate'],
          qty: alllist[i]['qty'],
        /*    attcnt : alllist[i]['attcnt']
        */
        );
        setState(() {
          planData.add(MhObject);
        });
      }
      return
        planData;
    } else {
      throw Exception('불러오는데 실패했습니다');
    }

  }




  @override
  Widget build(BuildContext context){
    return Scaffold(
       appBar: AppBar(
         iconTheme: IconThemeData(
           color: GlobalStyle.appBarIconThemeColor,
         ),
         elevation: GlobalStyle.appBarElevation,
         title: Text(
           '점검계획',
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
                 hintText: '현장검색',
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
      body:
      ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            padding:EdgeInsets.only(top:16, bottom: 2, left: 10),
            child: Text('점검계획  ${planData.length} 건',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
                )),
          ),
          SingleChildScrollView(

            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              height: 500,
              width: 1000,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  DataTable(
                      showCheckboxColumn: false,
                      columnSpacing: 25, dataRowHeight: 40,
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      headingRowColor:
                      MaterialStateColor.resolveWith((states) => SOFT_BLUE),
                      columns: <DataColumn>[
                        DataColumn(label: Text('No.')),
                        DataColumn(label: Text('검사일자')),
                        DataColumn(label: Text('코드')),
                        DataColumn(label: Text('현장명')),
                        DataColumn(label: Text('호기코드')),
                        DataColumn(label: Text('호기명')),
                        DataColumn(label: Text('검사자')),
                        DataColumn(label: Text('대수')),
                        DataColumn(label: Text('기타호기')),
                        DataColumn(label: Text('입력날짜')),

                      ],
                      rows: List<DataRow>.generate(planData.length, (index)
                      {
                        final plan_model item = planData[index];
                        return
                            DataRow(

                               /* onSelectChanged: (value){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => AppPage15view(MhData: item)));
                                },*/
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
                                      child: Text('${index+1}'),
                                    )
                                  ),
                                  DataCell(
                                      ConstrainedBox(
                                          constraints: BoxConstraints(minWidth: 60, maxWidth: 65),
                                          child: Text(item.plandate
                                          ))),
                                  DataCell(Container(
                                    width: 80,
                                    child: Text(item.actcd,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                                  DataCell(Container(
                                    width: 120,
                                    child: Text(item.actnm,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                                  DataCell(Container(
                                    width: 80,
                                    child: Text(item.equpcd,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                                  DataCell(Container(
                                    width: 50,
                                    child: Text(item.equpnm,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                                  DataCell(Container(
                                    width: 50,
                                    child: Text(item.pernm,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                                  DataCell(Container(
                                    width: 50,
                                    child: Text(item.qty,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                                  DataCell(Container(
                                    width: 120,
                                    child: Text(item.remark,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                                  DataCell(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(minWidth: 50, maxWidth: 50),
                                            child: Text('${item.indate}',
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
                      }))
                ],
              ),
            ),
          ),
          Container( ///노하우등록
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(12),
            child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager15register()));
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
                    '점검계획 등록',
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