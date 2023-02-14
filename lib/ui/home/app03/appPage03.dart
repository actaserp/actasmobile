import 'dart:convert';
// import 'dart:js';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/app03/MhmanualList_model.dart';

import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;



import '../tab_home.dart';
import 'appPage03_Edetail.dart';
import 'appPage03_detail.dart';
import 'appPage03_view.dart';

class AppPage03 extends StatefulWidget {


  @override
  _AppPage03State createState() => _AppPage03State();
}

class _AppPage03State extends State<AppPage03> {
  // 컨트롤러

  String _subsubsub = '';
  //초기화하고 값실어서 보내면

  List<DataRow> _dataGrid(MhmanualList_model MhData) {
    debugPrint('The value of a is $_dataGrid(MhData)');
    // Text(MhData.hseq) ${MhData.hgroupcd}
    return [
      DataRow(
        cells: <DataCell>[
          DataCell(
               ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 50), //SET max width
              child: Text('${MhData.hseq}',
              overflow: TextOverflow.ellipsis)),
          ),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 50), //SET max width
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
                    onTap: (){
                      setState(() {
                        this._subsubsub = '${MhData.hsubject}';
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage03view(MhData: MhData)));
                    },
                   child: ConstrainedBox(
                     constraints:  BoxConstraints(maxWidth: 50),
                     child: Text('${MhData.hsubject}',
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
                      constraints: BoxConstraints(maxWidth: 50), //SET max width
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
          );
          setState(() {
            MhData.add(MhObject);
          });
        }
        return
          // Fluttertoast.showToast(msg: '성공입니다.');
        MhData;
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
      body:
        ListView(
          padding: EdgeInsets.all(16),
          children:  [
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
                ),
              ),
                height: 700,
                width: 750,
                child: ListView.builder( //hassize is not true ~~~~~~~~~~~~~~~~~~~~~~~~~~~굿~~~
                      shrinkWrap: true,
                      itemCount: MhData.length,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return DataTable (
                          columnSpacing: 0,
                          dataRowHeight: 40,
                          columns:
                           <DataColumn>[
                                  DataColumn(label:
                                  Container(
                                      width: 30,
                                  child: Text('번호',
                                      style: TextStyle(fontWeight: FontWeight.bold,  color: CHARCOAL))),
                                  ),
                                  DataColumn(label:
                                  Text('분류',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                                  DataColumn(label: Text('제목',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                                  DataColumn(label: Text('작성자',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                                  DataColumn(label: Text('등록일자', style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
                          ], rows:
                           _dataGrid(MhData[index]),
                          );
                      },
                    ),
                    ),  //listview.builder endpoint
              ),
         //single~view endpoint
          //여기까지 dataRow
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

//////////////////////datacolumn list 시작




// Widget _buildList(BuildContext context, int index){
//   return DataTable(columns:
//     const <DataColumn>[
//         DataColumn(label: Text('번호',   style: TextStyle(fontWeight: FontWeight.bold,  color: CHARCOAL))),
//         DataColumn(label: Text('분류',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
//         DataColumn(label: Text('제목',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
//         DataColumn(label: Text('작성자',  style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
//         DataColumn(label: Text('첨부파일건수', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
//         DataColumn(label: Text('등록일자', style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
//         DataColumn(label: Text('수정/삭제', style: TextStyle(fontWeight: FontWeight.bold, color: CHARCOAL))),
//   ],
//
//       rows: dataGrid(MhData[index])
//   );
// }


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
            Fluttertoast.showToast(msg: '삭제 되었습니다.', toastLength: Toast.LENGTH_LONG);
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
      title: Text('수리노하우 게시글 삭제', style: TextStyle(fontSize: 18),),
      content: Text('해당 글을 삭제하시겠습니까?', style: TextStyle(fontSize: 13, color: BLACK_GREY)),
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
              // _buildFileList(),
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
                SizedBox(    //왼쪽 크기 정하기
                  width: 0,
                  height: 40,
                ),
                Text('첨부파일 목록', style: TextStyle(
                    fontSize: 20,
                    color: SOFT_BLUE,
                    fontWeight: FontWeight.bold
                ),
                ),
                SizedBox(
                  height: 20,
                ),
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
