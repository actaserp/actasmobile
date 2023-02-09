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

import '../../../model/popup/Comm751_model.dart';
import '../../../model/shopping_cart_model.dart';
import '../../general/product_detail/product_detail.dart';
import '../../reusable/cache_image_network.dart';

class EAppPage03Detail extends StatefulWidget {


  // final MhmanualList_model mhData;
  // const AppPage03Detail({Key? key, required this.mhData}) : super(key: key);

  @override
  _EAppPage03DetailState createState() => _EAppPage03DetailState();
}

class _EAppPage03DetailState extends State<EAppPage03Detail> {

  final List<String> _C751Data = [];
  final _reusableWidget = ReusableWidget();
  List<String> _goodParts = [];
  int _maxgoodParts = 2;

  late String _setTime;
  late String _hour, _minute, _time;
  late String _dbnm , _etrecedate, _etrecenum, _etrectime;
  String? _etGregicdTxt, _etRegicdTxt, _etResucdTxt ,_etResultcdTxt, _eCompdate, _eComptime ;   // _etRegicdTxt, _etResucdTxt, _etResultcdTxt, _etResuremarkTxt;


  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  // 값매핑1
  TextEditingController _mhCustcd = TextEditingController();
  TextEditingController _etAddressTitle = TextEditingController(text: 'Home Address');
  TextEditingController _etPostalCode = TextEditingController(text: '07093');
  TextEditingController _etState = TextEditingController(text: 'USA');


  @override
  void initState() {
    pop_Com751();
    setData();
    super.initState();
  }
  @override
  //값매핑2
  void setData(){
    _mhCustcd = TextEditingController(text: "dd");
  }
  @override
  Future pop_Com751()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/Com751';
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
        'greginm': '%',
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      C751Data.clear();
      _C751Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        if (alllist[i]['gregicd'] != null || alllist[i]['gregicd'].length > 0 ){
          Comm751_model emObject= Comm751_model(
              code:alllist[i]['code'],
              cnam:alllist[i]['cnam']
          );
          setState(() {
            C751Data.add(emObject);
            _C751Data.add(alllist[i]['code'] + '[' + alllist[i]['cnam'] + ']' );
          });
        }
      }

      return C751Data;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('고장부위 불러오는데 실패했습니다');
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
    //null처리
    // if(widget.e401Data.compdate == null  ) {
    //   showAlertDialog(context, "처리일자를 등록하세요");
    //   return false;
    // }
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        // 'recedate': widget.e401Data.recedate.toString(),
        // 'recenum': widget.e401Data.recenum.toString(),
        // 'resuremark': widget.e401Data.resuremark.toString(),
        'custcd': _mhCustcd.toString(),
      },
    );
    if(response.statusCode == 200){
      print("저장됨");
      return   true;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('수리노하우 수정에 실패했습니다');
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
            '노하우 수정',
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
                            hint: Text("분류", style: TextStyle(color: Colors.white)),
                            value: this._etGregicdTxt ,
                            items: _C751Data.map((item) {
                              return DropdownMenuItem<String>(
                                child: Text(item, style: TextStyle(color: Colors.white)),
                                value: item,
                              );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              // this._etGregicdTxt = value;
                              // widget.C751Data.code = value;
                            });
                            C751Data.clear();
                            _C751Data.clear();
                            pop_Com751();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
            _buildOptioncheckParts(),
            SizedBox(
              height: 20,
            ),
                      TextField(
                        controller: _etAddressTitle,
                        decoration: InputDecoration(
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

                    TextField(
                      enabled: false,
                      style: TextStyle(color: BLACK_GREY),
                      controller: _etPostalCode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                          ),
                          labelText: '작성자 *',
                          labelStyle:
                          TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _etAddressTitle,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
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
                          Container(
                            padding: EdgeInsets.all(16),
                            color: Colors.white,
                            child: Column(
                              children: List.generate(shoppingCartData.length,(index){
                                return _buildItem(index, boxImageSize);
                              }),
                            ),
                          ),
            SizedBox(
              height: 40,
            ),
            Container(
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) => SOFT_BLUE,
                    ),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        )
                    ),
                  ),
                  onPressed: () {
                    _reusableWidget.startLoading(context, '수정 되었습니다.', 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      '수정하기',
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
                            Row(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() {
                                      quantity--;
                                      shoppingCartData[index].setQty(quantity);
                                      // _countTotalPrice();
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    height: 28,
                                    decoration: BoxDecoration(
                                        color: SOFT_BLUE,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Icon(Icons.remove,
                                        color: Colors.white, size: 20),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: Text(quantity.toString(), style: TextStyle(

                                  )),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                      shoppingCartData[index].setQty(quantity);
                                      // _countTotalPrice();
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    height: 28,
                                    decoration: BoxDecoration(
                                        color: SOFT_BLUE,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Icon(Icons.add,
                                        color: Colors.white, size: 20),
                                  ),
                                )
                              ],
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

  
  //체크 박스
  Widget _buildOptioncheckParts(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                ],
              ),
              _checboxgood(value: 'breast' , primaryText: '회원사 공유 여부'),
              // Divider(
              //   height: 32,
              //   color: Colors.grey[400],
              // ),
              // _checboxgood(value: 'wings', primaryText: 'Chicken Wings', secondaryText: '0'),
            ],
          ),
        )
      ],
    );
  }


  //체크박스
  Widget _checboxgood({value = 'breast' , primaryText: '회원사 공유 여부'}){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        setState(() { //tap 시에 value 다시 잡아주고
          if(_goodParts.contains(value)){
            _goodParts.remove(value);
          } else {
            if(_goodParts.length<_maxgoodParts){
              _goodParts.add(value);
            }
          }
        });
      },
      child: Row(
        children: [
          Text(primaryText, style: TextStyle(
              fontSize: 15,
              color: SOFT_BLUE,
              fontWeight: (_goodParts.contains(value))?FontWeight.bold:FontWeight.normal
          )),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: (_goodParts.contains(value)) ? PRIMARY_COLOR : BLACK77
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(4.0)
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: (_goodParts.contains(value))
                  ? Icon(
                Icons.check,
                size: 12.0,
                color: PRIMARY_COLOR,
              ):Icon(
                Icons.check_box_outline_blank,
                size: 12.0,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 16),


          // Spacer(),
          // Text(secondaryText, style: TextStyle( //수량나타내주는거
          //   fontSize: 13,
          //   color: BLACK77,
          // ))
        ],
      ),
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

}
