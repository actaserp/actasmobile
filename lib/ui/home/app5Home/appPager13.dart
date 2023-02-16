import 'dart:convert';

import 'package:actasm/model/app02/mfixlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../../config/constant.dart';
import '../../../config/global_style.dart';



class AppPager13 extends StatefulWidget {


  @override
  _AppPager13State createState() => _AppPager13State();
}

class _AppPager13State extends State<AppPager13> {


  String _subsubsub = '';
  
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
               child: Text('${mfixData.fgourpcd}',
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
                        /*Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage03view(MhData: MhData)));
                        */
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
    mfixlist_getdata();
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
        'dbnm': _dbnm
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
          cnam: alllist[i]['cnam']
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
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        // bottom: _reusableWidget.bottomAppBar(),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('점검조치사항 자료실', style: TextStyle(
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
              height: 300 ,
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
          Container( //노하우등록임
            margin: EdgeInsets.only(top: 10),
            child: OutlinedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage03Detail(MhData: MhData, MhData: null,)));
                 /* Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AppPage03Detail()));
*/
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
}