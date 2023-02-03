import 'dart:convert';

import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/coupon_model.dart';
import 'package:actasm/model/app01/e401list_model.dart';
import 'package:actasm/ui/home/coupon_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../model/app01/e401list_model.dart';

class CouponPage extends StatefulWidget {
  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  TextEditingController _etSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    e401list_getdata() ;
  }
  @override
  void dispose() {
    _etSearch.dispose();
    super.dispose();
  }


  Future e401list_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/e401list';
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
      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      e401Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        e401list_model emObject= e401list_model(
          remark:alllist[i]['remark'],
          contents:alllist[i]['contents'],
          actperid:alllist[i]['actperid'],
          perid:alllist[i]['perid'],
          frdate:alllist[i]['frdate'],
          todate:alllist[i]['todate'],
          recedate:alllist[i]['recedate'],
          recenum:alllist[i]['recenum'],
          actcd:alllist[i]['actcd'],
          actnm:alllist[i]['actnm'],
          equpcd:alllist[i]['equpcd'],
          equpnm:alllist[i]['equpnm'],
          actpernm:alllist[i]['actpernm'],
          pernm:alllist[i]['pernm'],
          contcd:alllist[i]['contcd'],
          contnm:alllist[i]['contnm'],
          contremark:alllist[i]['contremark'] ,
          recetime:alllist[i]['recetime']
        );
        e401Data.add(emObject);
      }
      return e401Data;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
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
            '고장 미처리 리스트 : ' + e401Data.length.toString(),
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
                  hintText: '보수현장명',
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
        body: WillPopScope(
          onWillPop: (){
            Navigator.pop(context);
            return Future.value(true);
          },
          child: ListView.builder(
            itemCount: e401Data.length,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            physics: AlwaysScrollableScrollPhysics(),
            // Add one more item for progress indicator
            itemBuilder: (BuildContext context, int index) {
              print(index);
              return _buildCouponCard(e401Data[index]);
            },
          ),


        ));
  }

  Widget _buildCouponCard(e401list_model e401Data){
    return Card(
      margin: EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 2,
      color: Colors.white,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context) => CouponDetailPage(couponData: e401list_data)));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                decoration: BoxDecoration(
                    color: SOFT_BLUE,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Text('Limited Offer', style: GlobalStyle.couponLimitedOffer),
              ),
              SizedBox(height: 12),
              Text(e401Data.actnm, style: GlobalStyle.couponName),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GlobalStyle.iconTime,
                      SizedBox(
                        width: 4,
                      ),
                      Text('Expiring in '+e401Data.recedate+' days', style: GlobalStyle.couponExpired),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      Fluttertoast.showToast(msg: 'Coupon applied', toastLength: Toast.LENGTH_LONG);
                      Navigator.pop(context);
                    },
                    child: Text('Use Now', style: TextStyle(
                        fontSize: 14, color: SOFT_BLUE, fontWeight: FontWeight.bold
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
