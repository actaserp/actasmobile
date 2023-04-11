import 'dart:convert';
import 'dart:ffi';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../model/app03/MhmanualList_model.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;

import '../../../model/popup/Comm754_model.dart';
import '../../../model/shopping_cart_model.dart';
import '../../general/product_detail/product_detail.dart';
import '../../reusable/cache_image_network.dart';

class EAppPage03Detail extends StatefulWidget {
  // final MhmanualList_model MhData;
  // const EAppPage03Detail({Key? key, required this.MhData}) : super(key: key);

  @override
  _EAppPage03DetailState createState() => _EAppPage03DetailState();
}

class _EAppPage03DetailState extends State<EAppPage03Detail> {

  final List<String> _C754Data = [];
  final _reusableWidget = ReusableWidget();
  List<String> _goodParts = [];
  int _maxgoodParts = 2;

  late String _setTime;
  late String _hour, _minute, _time;
  late String _dbnm, _etrecedate, _etrectime;


  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(),
      initialDate = DateTime.now();

  // 값매핑1
  TextEditingController _mHCustcd = TextEditingController();
  TextEditingController _mHSpjangcd = TextEditingController();
  TextEditingController _mHRemark = TextEditingController();
  TextEditingController _mHHseq = TextEditingController();
  TextEditingController _mHHinputdate = TextEditingController();
  TextEditingController _mHHgroupcd = TextEditingController();
  TextEditingController _mHSubject = TextEditingController();
  TextEditingController _mHFilename = TextEditingController();
  TextEditingController _mHHPernm = TextEditingController();
  TextEditingController _mHHmemo = TextEditingController();
  TextEditingController _mHHflag = TextEditingController();
  TextEditingController _mHAttcnt = TextEditingController();
  TextEditingController _mHCnam = TextEditingController();


  String? _mHCode;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double boxImageSize = (MediaQuery
        .of(context)
        .size
        .width / 5);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: GlobalStyle.appBarIconThemeColor,
          ),
          elevation: GlobalStyle.appBarElevation,
          title: Text(
            'Test',
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          bottom: _reusableWidget.bottomAppBar(),
        ),
      body:
      Scrollbar(
        thickness: 8.0,
        isAlwaysShown: true,
        child: ListView(
          ///막으면 전체화면
          children: [
            Container(
              padding:EdgeInsets.only(top:16, bottom: 2, left: 10),
              child: Text('수리 노하우 자료실  ${MhData.length} 건',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
                  )),
            ),
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    // padding: EdgeInsets.all(16),
                    height: 400,
                    width: 900,
                    child: ListView(
                      // physics: NeverScrollableScrollPhysics(),
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
                                              child: Text(item.hgroupcd,
                                                  overflow: TextOverflow.ellipsis
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
                        ]),
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width/0.6,
                    margin: EdgeInsets.only(top: 10, bottom: 15),
                    padding: EdgeInsets.all(12),
                    child: OutlinedButton(
                        onPressed: () {
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
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


}