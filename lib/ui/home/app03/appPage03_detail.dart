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

class AppPage03Detail extends StatefulWidget {


  // final MhmanualList_model mhData;
  // const AppPage03Detail({Key? key, required this.mhData}) : super(key: key);

  @override
  _AppPage03DetailState createState() => _AppPage03DetailState();
}

class _AppPage03DetailState extends State<AppPage03Detail> {
  ///처리등록되었습니다 startloading
  final _reusableWidget = ReusableWidget();
  final List<String> _C754Data = [];
  late String _dbnm ;
  String? _codeTxt;
///작성자
  var _usernm = "";
///timepicker
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  ///저장전 등록 controller
  TextEditingController _mhCustcd = TextEditingController();
  ///여기서부터 blank
  TextEditingController _memo = TextEditingController();
  TextEditingController _subject = TextEditingController();
  TextEditingController _etCompdate = TextEditingController();



  @override
  void initState() {
    sessionData();
    pop_Com75to00();
    setData();
    super.initState();
  }
  @override

  ///저장시 setData
  void setData(){


  }

  Future<void> sessionData() async {
    _usernm = await  SessionManager().get("username");
  }
  @override
  Future pop_Com75to00()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/Com754to00';
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
        'cnam': '%',
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      C754Data.clear();
      _C754Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        if (alllist[i]['code'] != null || alllist[i]['code'].length > 0 ){
          Comm754_model emObject= Comm754_model(
              code:alllist[i]['code'],
              cnam:alllist[i]['cnam']
          );
          setState(() {
            C754Data.add(emObject);
            _C754Data.add(alllist[i]['code'] + '/' + alllist[i]['cnam']);
          });
        }
      }

      return C754Data;
    }else{
      throw Exception('분류 코드를 불러오는데 실패했습니다');
    }
  }
  //저장
  @override
  Future<bool> save_mhdata()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/saveeMh';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");
    ///null처리
    if(_etCompdate.text == null || _etCompdate.text == "") {
      showAlertDialog(context, "작성일자를 등록하세요");
      return false;
    }
    if(_subject == null || _subject == "" ) {
      showAlertDialog(context, "작성일자를 등록하세요");
      return false;
    }
    if(_memo == null || _memo == "" ) {
      showAlertDialog(context, "작성일자를 등록하세요");
      return false;
    }
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        ///저장시 필수 값
        ///custcd, spjangcd, hseq 컨트롤러
        'hinputdate': _etCompdate.toString(),
        'hpernm': _usernm.toString(),
       'hmemo': _memo.toString(),
        'hsubject': _subject.toString(),
        'hgroupcd': this._codeTxt.toString(), //작성된 groupcd랑 이름
      },
    );
    if(response.statusCode == 200){
      print("저장됨");
      return   true;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('수리노하우 저장에 실패했습니다');
      return   false;
    }
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double boxImageSize = (MediaQuery.of(context).size.width / 5);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: GlobalStyle.appBarIconThemeColor,
          ),
          elevation: GlobalStyle.appBarElevation,
          title: Text(
            '노하우 등록',
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          bottom: _reusableWidget.bottomAppBar(),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
                    Card(
                      color: SOFT_BLUE,
                      elevation: 5,
                      child:
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: Icon(Icons.keyboard_arrow_down),
                            dropdownColor: Colors.blue[800],
                            iconEnabledColor: Colors.white,
                            hint: Text("분류 *", style: TextStyle(color: Colors.white)),
                            value: this._codeTxt != null? this._codeTxt :null ,
                            items: _C754Data.map((item) {
                              return DropdownMenuItem<String>(
                                child: Row(
                                  children: [
                                    Text(item, style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                                value: item,
                              );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              this._codeTxt = value;

                            });
                            // C754Data.clear();
                            // _C754Data.clear();
                            // pop_Com75to00();
                          },
                        ),
                      ),
                    ),
                  ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _etCompdate,
                          readOnly: true,
                          onTap: () {
                            _selectDateWithMinMaxDate(context);
                          },
                          maxLines: 1,
                          cursorColor: Colors.grey[600],
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                              // fillColor: Colors.grey[200],
                              // filled: true,
                              isDense: true,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: '작성일자를 입력하세요',
                              suffixIcon: Icon(Icons.date_range, color: Colors.pinkAccent),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[600]!),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[600]!),
                              ),
                              labelText: '작성일자 *',
                              labelStyle:
                              TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      TextField(
                        controller: _subject,
                        autofocus: true,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: '제목을 작성하세요',
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                            ),
                            labelText: '제목 *',
                            labelStyle:
                            TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text( _usernm,
                          style: TextStyle(color: SOFT_BLUE ,fontSize: 18,fontWeight: FontWeight.bold),
                             ),
                          Text( '님이 작성 중입니다.',
                            style: TextStyle(color: BLACK_GREY ,fontSize: 18),
                          ),
                        ],
                      ),

                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            autofocus: true,
                            controller: _memo,
                            decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: '내용을 작성하세요',
                                focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide:
                                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                                ),
                                labelText: '내용 *',
                                labelStyle:
                                TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
            ///첨부파일입력 시작
            Row(
              children: [
                            SizedBox(    //왼쪽 크기 정하기
                              width: 0,
                              height: 40,
                            ),
                            Text('첨부파일 목록', style: TextStyle(
                                fontSize: 16,
                                color: SOFT_BLUE,
                                fontWeight: FontWeight.bold
                            ),
                                textAlign: TextAlign.center
                            ),
                            SizedBox(
                              height: 20,
                            ),
                      ],
            ),
            Row(
              children: [
                SizedBox(width: 500
                ),
                GestureDetector(
                  onTap: (){
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: SOFT_BLUE,
                      border: Border.all(
                        color: SOFT_BLUE,
                      ),

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Text('업로드', style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold,
                      ),
                          textAlign: TextAlign.center
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ///첨부파일 list 시작
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: List.generate(shoppingCartData.length,(index){
                  return _buildItem(index, boxImageSize);
                }),
              ),
            ),

            ///등록 시작
            SizedBox(
              height: 40,
            ),
            Container(
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) => SOFT_BLUE,
                    ),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        )
                    ),
                  ),
                  onPressed: () {
                    _reusableWidget.startLoading(context, '등록 되었습니다.', 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      '등록하기',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
              ),
            ),
          ],
        )
    );
  }


  //  첨부파일리스트 ~ network로 가져와야함
  Column _buildItem(index, boxImageSize){
    int quantity = shoppingCartData[index].qty;
    return Column(
      children: [
        Container(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(name: shoppingCartData[index].name, image: shoppingCartData[index].image, price: shoppingCartData[index].price, rating: 4, review: 23, sale: 36)));
                  },
                  child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(4)),
                      child: buildCacheNetworkImage(width: boxImageSize, height: boxImageSize, url: shoppingCartData[index].image)),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(name: shoppingCartData[index].name, image: shoppingCartData[index].image, price: shoppingCartData[index].price, rating: 4, review: 23, sale: 36)));
                        },
                        child: Text(
                          shoppingCartData[index].name,
                          style: GlobalStyle.productName.copyWith(fontSize: 14),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        // child: Text('\$ '+_globalFunction.removeDecimalZeroFormat(shoppingCartData[index].price),
                        //     style: GlobalStyle.productPrice),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                // showPopupDelete(index, boxImageSize);
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1, color: Colors.grey[300]!)),
                                child: Icon(Icons.delete,
                                    color: BLACK_GREY, size: 20),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        (index == shoppingCartData.length - 1)
            ? Wrap()
            : Divider(
          height: 32,
          color: Colors.grey[400],
        )
      ],
    );
  }


//저장시 confirm
  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('수리노하우'),
          content: Text(as_msg),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "확인");
              },
            ),
          ],
        );
      },
    );
  }

  ///datepicker
  Future<Null> _selectDateWithMinMaxDate(BuildContext context) async {
    var firstDate = DateTime(initialDate.year, initialDate.month - 3, initialDate.day);
    var lastDate = DateTime(initialDate.year, initialDate.month, initialDate.day + 7);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.pinkAccent,
            colorScheme: ColorScheme.light(primary: Colors.pinkAccent, secondary: Colors.pinkAccent),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _eCompdate = _selectedDate.toLocal().toString().split(' ')[0];
        _etCompdate = TextEditingController(
            text: _selectedDate.toLocal().toString().split(' ')[0]);
      });
    }
  }
}
