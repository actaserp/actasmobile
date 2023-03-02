import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/mnoticeList_model.dart';
import 'appPager14Detail.dart';

class AppPager14 extends StatefulWidget {


  @override
  _AppPager14State createState() => _AppPager14State();
}

class _AppPager14State extends State<AppPager14>{

  String _subsubsub = '';
  TextEditingController _etSearch2 = TextEditingController();
  List<mnoticeList_model> mnoticeDatas = mnoticeData;



  List<DataRow> _dataGrid(mnoticeList_model mnoticeData){
    return [
      DataRow(
        cells: <DataCell>[
          DataCell(
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        this._subsubsub = '${mnoticeData.nseq}';
                      });

                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager14Detail(mnoticeData: mnoticeData)));

                    },
                    child: ConstrainedBox(
                      constraints:  BoxConstraints(minWidth: 70 , maxWidth: 70),
                      child: Text('${mnoticeData.nseq}',
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
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        this._subsubsub = '${mnoticeData.cnam}';
                      });

                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager14Detail(mnoticeData: mnoticeData)));

                    },
                    child: ConstrainedBox(
                      constraints:  BoxConstraints(minWidth: 60 , maxWidth: 60),
                      child: Text('${mnoticeData.cnam}',
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
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        this._subsubsub = '${mnoticeData.nsubject}';
                      });

                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager14Detail(mnoticeData: mnoticeData)));

                    },
                    child: ConstrainedBox(
                      constraints:  BoxConstraints(minWidth: 150 , maxWidth: 150),
                      child: Text('${mnoticeData.nsubject}',
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
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        this._subsubsub = '${mnoticeData.npernm}';
                      });

                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager14Detail(mnoticeData: mnoticeData)));

                    },
                    child: ConstrainedBox(
                      constraints:  BoxConstraints(minWidth: 60 , maxWidth: 60),
                      child: Text('${mnoticeData.npernm}',
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
                  Container(
                    // margin: EdgeInsets.only(right: 5),
                  ),
                  Text('${mnoticeData.ninputdate}')
                ],
              )
          ),

        ],
      ),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mnoticelist_getdata();
  }

  @override
  void dispose(){
    super.dispose();
  }

  Future mnoticelist_getdata() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/apppgymobile/mnoticelist';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
      },
      body: <String, String>{
        'dbnm': _dbnm,
        'nsubject': _etSearch2.text,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> alllist = [];
      alllist = jsonDecode(utf8.decode(response.bodyBytes));
      mnoticeData.clear();
      for (int i = 0; i < alllist.length; i++) {
        mnoticeList_model Object = mnoticeList_model(

            nseq: alllist[i]['nseq'],
            ninputdate: alllist[i]['ninputdate'],
            ngourpcd: alllist[i]['ngourpcd'],
            nsubject: alllist[i]['nsubject'],
            npernm: alllist[i]['npernm'],
            nmemo: alllist[i]['nmemo'],
            cnam: alllist[i]['cnam'],
            nflag: alllist[i]['nflag'],
            attcnt: alllist[i]['attcnt'],
        );
        setState(() {
          mnoticeData.add(Object);
        });
      }
      return
        // Fluttertoast.showToast(msg: '성공입니다.');
        mnoticeData;
      //   debugPrint('The value of a is $MhData');

    } else {
      // Fluttertoast.showToast(msg: e.toString());
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
          '공지사항',
          style: GlobalStyle.appBarTitle,
        ),
        actions: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(onPressed: (){

                  setState(() {

                    mnoticelist_getdata();
                  });
                  /*searchBook(_etSearch.text);*/
                  /*searchBook2(_etSearch2.text);*/
                }, child: Text('검색하기')),
              ),

            ],
          )
        ],
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _etSearch2,
            textAlignVertical: TextAlignVertical.bottom,
            maxLines: 1,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),

            decoration: InputDecoration(
              fillColor: Colors.grey[100],
              filled: true,
              hintText: '게시글 제목검색',
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
                  borderSide: BorderSide(color: Colors.grey[200]!)),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
            ),
          ),
          Container(
            padding:EdgeInsets.only(top:16, bottom: 2, left: 10),
            child: Text('공지사항 ${mnoticeData.length} 건',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
                )),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              // padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.702,
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
                      columns: <DataColumn>[
                        DataColumn(label: Text('No.')),
                        DataColumn(label: Text('분류')),
                        DataColumn(label: Text('제목')),
                        DataColumn(label: Text('내용')),
                        DataColumn(label: Text('작성자')),
                        DataColumn(label: Text('첨부파일건수')),
                        DataColumn(label: Text('작성일자')),
                      ],
                      rows: List<DataRow>.generate(mnoticeData.length, (index){
                        final mnoticeList_model item = mnoticeData[index];
                        return
                            DataRow(
                                onSelectChanged: (value){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => AppPager14Detail(mnoticeData: item)));
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
                                          child: Text(item.cnam
                                          ))),
                                  DataCell(Container(
                                    width: 180,
                                    child: Text(item.nsubject,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                                  DataCell(Container(
                                    width:180,
                                    child: Text(item.nmemo,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                                  DataCell(Text(item.npernm,
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
                                            child: Text('${item.ninputdate}',
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
          )
          /*SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.only(top: 15),

              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xffcccccc),
                    width: 1.0,
                  ),
                ),
              ),

              height: 600,
              width: 700,
              child: ListView.builder(shrinkWrap: true, itemCount: mnoticeData.length,
                  itemBuilder: (BuildContext context, int index){
                    return DataTable (
                      columnSpacing: 10,
                      dataRowHeight: 40,
                      columns:
                      <DataColumn>[

                        DataColumn(label: Text('번호',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                        DataColumn(label: Text('분류',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                        DataColumn(label: Text('제목',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                        DataColumn(label: Text('작성자',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                        DataColumn(label: Text('등록일자', style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                      ], rows:
                    _dataGrid(mnoticeData[index]),
                    );
                  }),
            ),
          ),*/
          /*Container( //노하우등록임
            margin: EdgeInsets.only(top: 10),
            child: OutlinedButton(
                onPressed: () {

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AppPager13register()));

                   Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager13register()));

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
                    '공지사항 등록',
                    style: TextStyle(
                        color: SOFT_BLUE,
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
            ),
          )*/

        ],
      ),
    );
  }


  static double scaleWidth(BuildContext context){
    const designWidth = 420;
    final diff =  designWidth /getDeviceWidth(context) ;
    return diff;
  }

  static getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}




