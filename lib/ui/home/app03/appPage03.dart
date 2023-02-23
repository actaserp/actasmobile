import 'dart:convert';
import 'dart:io';
// import 'dart:js';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app03/MhmanualList_model.dart';
import 'package:actasm/ui/home/app03/Nav_right.dart';

import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../tab_home.dart';
import 'appPage03_Edetail.dart';
import 'appPage03_detail.dart';
import 'appPage03_view.dart';

class AppPage03 extends StatefulWidget {


  @override
  _AppPage03State createState() => _AppPage03State();
}

class _AppPage03State extends State<AppPage03> {
  TextEditingController _etSearch = TextEditingController();

  late final String good;

  ///fileview
  final mobUrl = "";
  bool downloading = false;
  final List<String> _SCData = [];
  late String _dbnm, _subkey;

  @override
  void initState() {
    super.initState();
    mhlist_getdata();
  }

  @override
  void dispose() {
    _etSearch.dispose();
    super.dispose();
  }



  Future mhlist_getdata() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/mhlist';
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
        'dbnm': _dbnm
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> alllist = [];
      alllist = jsonDecode(utf8.decode(response.bodyBytes));
      MhData.clear();
      for (int i = 0; i < alllist.length; i++) {
        MhmanualList_model MhObject = MhmanualList_model(
          custcd: alllist[i]['custcd'],
          spjangcd: alllist[i]['spjangcd'],
          hseq: alllist[i]['hseq'],
          hinputdate: alllist[i]['hinputdate'],
          hgroupcd: alllist[i]['hgroupcd'],
          hsubject: alllist[i]['hsubject'],
          hpernm: alllist[i]['hpernm'],
          hmemo: alllist[i]['hmemo'],
          hflag: alllist[i]['hflag'],
          attcnt : alllist[i]['attcnt']
        );
        setState(() {
          MhData.add(MhObject);
        });
      }
      print( 'test:::: ${MhData[9].attcnt}');
      return
        MhData;
    } else {
      throw Exception('불러오는데 실패했습니다');
    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer: Nav_right(
        text: Text('app03_nav'),
        color: SOFT_BLUE,
      ),
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
      body:
      ListView(
        physics: NeverScrollableScrollPhysics(),
       ///막으면 전체화면
       // padding: EdgeInsets.all(16),
        children: [
          Container(
            padding:EdgeInsets.only(top:16, bottom: 2, left: 10),
            child: Text('수리 노하우 자료실  ${MhData.length} 건',
                style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
            )),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
                margin: EdgeInsets.only(top: 15),
              // padding: EdgeInsets.all(16),
              height: 700,
              width: 900,
              child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    DataTable(
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
                      ],
                  rows: List<DataRow>.generate(MhData.length, (index)
                     {
                    final MhmanualList_model item = MhData[index];
                    return
                      DataRow(
                        ///longpress
                      //   onLongPress: (){
                      //     Navigator.push(context, MaterialPageRoute(
                      //         builder: (context) => AppPage03view(MhData: item)));
                      // },
                          onSelectChanged: (value){
                          Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AppPage03view(MhData: item)));
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
                          child: Text(item.hgroupcd
                          ))),
                      DataCell(Container(
                        width: 180,
                        child: Text(item.hsubject,
                          overflow: TextOverflow.ellipsis),
                      )),
                      DataCell(Container(
                        width:180,
                        child: Text(item.hmemo,
                            overflow: TextOverflow.ellipsis),
                      )),
                      DataCell(Text(item.hpernm,
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
                                  child: Text('${item.hinputdate}',
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
                      builder: (context) => AppPage03Detail()));
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


}