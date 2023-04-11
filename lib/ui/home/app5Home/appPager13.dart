import 'dart:convert';

import 'package:actasm/model/app02/e411list_model.dart';
import 'package:actasm/model/app02/mfixlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import 'appPager13Detail.dart';
import 'appPager13register.dart';



class AppPager13 extends StatefulWidget {


  @override
  _AppPager13State createState() => _AppPager13State();
}

class _AppPager13State extends State<AppPager13> {


  String _subsubsub = '';
  TextEditingController _etSearch2 = TextEditingController();
  List<mfixlist_model> mfixDatas = mfixData;


  List<DataRow> _dataGrid(mfixlist_model mfixData){
    return [
      DataRow(
        cells: <DataCell>[
          DataCell(
            ConstrainedBox(constraints: BoxConstraints(maxWidth: 75),
                child: Text('${mfixData.fseq}',
                    overflow: TextOverflow.ellipsis)),
          ),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ConstrainedBox(constraints: BoxConstraints(maxWidth: 55, minWidth: 50),
                    child: Text('${mfixData.cnam}',
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
                    onTap: (){
                      setState(() {
                        this._subsubsub = '${mfixData.fnsubject}';
                      });

                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager13Detail(mfixData: mfixData)));

                    },
                    child: ConstrainedBox(
                      constraints:  BoxConstraints(minWidth: 180 , maxWidth: 180),
                      child: Text('${mfixData.fnsubject}',
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
                      child: Text('${mfixData.fpernm}',
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
                  Text('${mfixData.finputdate}')
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

  setState(() {
    mfixlist_getdata();
  });

  }

  @override
  void dispose() {
    super.dispose();
  }

  Future mfixlist_getdata() async {
    String _dbnm = await SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/mfixlist';
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
        'fnsubject': _etSearch2.text,
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> alllist = [];
      alllist = jsonDecode(utf8.decode(response.bodyBytes));
      mfixData.clear();
      for (int i = 0; i < alllist.length; i++) {
        mfixlist_model Object = mfixlist_model(

            fseq: alllist[i]['fseq'],
            finputdate: alllist[i]['finputdate'],
            fgourpcd: alllist[i]['fgourpcd'],
            fnsubject: alllist[i]['fnsubject'],
            fpernm: alllist[i]['fpernm'],
            fmemo: alllist[i]['fmemo'],
            cnam: alllist[i]['cnam'],
            fflag: alllist[i]['fflag'],
            attcnt: alllist[i]['attcnt'],
        );
        setState(() {
          mfixData.add(Object);
        });
      }
      return
        // Fluttertoast.showToast(msg: '성공입니다.');
        mfixData;
      //   debugPrint('The value of a is $MhData');

    } else {
      // Fluttertoast.showToast(msg: e.toString());
      throw Exception('불러오는데 실패했습니다');

    }
    // } catch (e) {
    //   //만약 응답이 ok가 아니면 에러를 던집니다.
    //   Fluttertoast.showToast(msg: '에러입니다.');
    //   return <MhmanualList_model>[];
    // }
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
          '점검조치사항',
          style: GlobalStyle.appBarTitle,
        ),
        actions: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(onPressed: (){

                  setState(() {

                    mfixlist_getdata();

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
        // bottom: _reusableWidget.bottomAppBar(),
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
          /*Text('점검조치사항 자료실', style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
          )),*/
          Container(
            padding:EdgeInsets.only(top:16, bottom: 2, left: 10),
            child: Text('점검조치사항 ${mfixData.length} 건',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
                )),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              height: 0.638 * MediaQuery.of(context).size.height,
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
                      rows: List<DataRow>.generate(mfixData.length, (index)
                      {
                        final mfixlist_model item = mfixData[index];
                        return
                            DataRow(
                              onSelectChanged: (value){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AppPager13Detail(mfixData: item)));
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
                                  child: Text(item.fnsubject,
                                      overflow: TextOverflow.ellipsis),
                                )),
                                DataCell(Container(
                                  width:180,
                                  child: Text(item.fmemo,
                                      overflow: TextOverflow.ellipsis),
                                )),
                                DataCell(Text(item.fpernm,
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
                                          child: Text('${item.finputdate}',
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
                              ]

                            );
                      }
                  )
                  ),],
              ),
            ),
          ),
          /*SingleChildScrollView(
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
                ),
              ),
              height: 500 ,
              width: 700 ,
              child: ListView.builder( //hassize is not true ~~~~~~~~~~~~~~~~~~~~~~~~~~~굿~~~
                shrinkWrap: true,
                itemCount: mfixData.length,
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return DataTable (
                    columnSpacing: 10,
                    dataRowHeight: 40,
                    columns:
                    <DataColumn>[
                      // DataColumn(label:
                      // Container(
                      //     width: 30,
                      // child: Text('번호',
                      //     style: TextStyle(fontWeight: FontWeight.bold,  color: CHARCOAL))),
                      // ),
                      DataColumn(label: Text('번호',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('분류',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('제목',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('작성자',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                      DataColumn(label: Text('등록일자', style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                    ], rows:
                  _dataGrid(mfixData[index]),
                  );
                },
              ),
            ),  //listview.builder endpoint
          ),*/
          Container( ///노하우등록
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(12),
            child: OutlinedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage03Detail(MhData: MhData, MhData: null,)));
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AppPager13register()));
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
                    '점검조치사항 등록',
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

  static double scaleWidth(BuildContext context){
    const designWidth = 420;
    final diff =  designWidth /getDeviceWidth(context) ;
    return diff;
  }

  static getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
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
}