import 'dart:convert';
import 'dart:io';
// import 'dart:js';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app03/MhmanualList_model.dart';

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


  ///fileview
  final mobUrl = "";
  bool downloading = false;
  final List<String> _SCData = [];
  late String _dbnm, _subkey;



  List<DataRow> _dataGrid(MhmanualList_model MhData) {
    debugPrint('The value of a is $_dataGrid(MhData)');
    return [
      DataRow(
        cells: <DataCell>[
          // DataCell(
          //      ConstrainedBox(
          //       constraints: BoxConstraints(maxWidth: 75), //SET max width
          //     child: Text('${MhData.hseq}',
          //     overflow: TextOverflow.ellipsis)),
          // ),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 55, minWidth: 50),
                    //SET max width
                    child: Text('${MhData.hgroupcd}',
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          DataCell(
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AppPage03view(MhData: MhData)));
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 105, maxWidth: 105),
                      child: Text('${MhData.hsubject}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: SOFT_BLUE,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
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
                    constraints: BoxConstraints(maxWidth: 70, minWidth: 70),
                    //SET max width
                    child: Text('${MhData.hmemo}',
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 50), //SET max width
                      child: Text('${MhData.hpernm}',
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
                  Text('${MhData.hinputdate}')
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
    mhlist_getdata();
  }

  @override
  void dispose() {
    _etSearch.dispose();
    super.dispose();
  }


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // 파일 읽기
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // 에러가 발생할 경우 0을 반환
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // 파일 쓰기
    return file.writeAsString('$counter');
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
        );
        setState(() {
          MhData.add(MhObject);
        });
      }
      return
        MhData;
    } else {
      throw Exception('불러오는데 실패했습니다');
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(child:
              Text('Actas',
              style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
        ),
            ),
              decoration: BoxDecoration(
                color: Colors.blue[800]
              ),
            ),
            ListTile(
                title: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TabHomePage()));
                    },
                    child:  Row(
                        children:[
                          Icon(
                            Icons.home,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Home'),
                        ]))),
            ListTile(
              title: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage02()));
                },
                  child:  Row(
                    children:[
                      Icon(
                        Icons.favorite,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('고장 처리'),
                    ]))),
            ListTile(
                title: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TabHomePage()));},
                    child:  Row(
                        children:[
                          Icon(
                            Icons.safety_check,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('현장 정보'),
                        ]))),
            ListTile(
                title: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TabHomePage()));},
                    child:  Row(
                        children:[
                          Icon(
                            Icons.person_outlined,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Account'),
                        ]))),
          ],
        ),
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
        padding: EdgeInsets.all(16),
        children: [
          Text('수리 노하우 자료실', style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
          )),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container( //높이랑 너비가 없었음
              margin: EdgeInsets.only(top: 15),
              // padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xffcccccc),
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: Color(0xffcccccc),
                    width: 1.0,
                  ),
                ),
              ),
              height: 700,
              width: 750,
              child: ListView
                  .builder( //hassize is not true ~~~~~~~~~~~~~~~~~~~~~~~~~~~굿~~~
                shrinkWrap: true,
                itemCount: MhData.length,
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return DataTable(
                    columnSpacing: 10,
                    dataRowHeight: 40,
                    columns:
                    <DataColumn>[
                      DataColumn(label: Text('분류', style: TextStyle(
                          fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('제목', style: TextStyle(
                          fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('내용', style: TextStyle(
                          fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('작성자', style: TextStyle(
                          fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('등록일자', style: TextStyle(
                          fontWeight: FontWeight.bold, color: CHARCOAL))),
                    ], rows:
                  _dataGrid(MhData[index]),
                  );
                },
              ),
            ), //listview.builder endpoint
          ),
          Container( //노하우등록임
            margin: EdgeInsets.only(top: 10),
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