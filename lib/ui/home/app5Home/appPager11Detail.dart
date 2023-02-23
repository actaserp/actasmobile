import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/tbe601list_model.dart';
import '../app03/Nav_right.dart';

class AppPager11Detail extends StatefulWidget{

  final tbe601list_model e601Data;

  const AppPager11Detail({Key? key, required this.e601Data}) : super(key: key);


  @override
  _AppPager11DetailState createState() => _AppPager11DetailState();

}

class _AppPager11DetailState extends State<AppPager11Detail> {

  TextEditingController _etactnm   = TextEditingController();
  TextEditingController _etelno    = TextEditingController();
  TextEditingController _etequpnm  = TextEditingController();
  TextEditingController _etactaddr = TextEditingController();
  TextEditingController _ettel     = TextEditingController();
  TextEditingController _ethp      = TextEditingController();
  TextEditingController _etpernm   = TextEditingController();
  TextEditingController _etemtelnum = TextEditingController();


  @override
  void initState(){
    setData();
    super.initState();
  }


  @override
  void setData(){
    _etactnm       =  TextEditingController(text: widget.e601Data.actnm);
    _etelno       =  TextEditingController(text: widget.e601Data.elno);
    _etequpnm       =  TextEditingController(text: widget.e601Data.equpnm);
    _etactaddr       =  TextEditingController(text: widget.e601Data.actaddr);
    _ettel       =  TextEditingController(text: widget.e601Data.tel);
    _ethp       =  TextEditingController(text: widget.e601Data.hp);
    _etpernm       =  TextEditingController(text: widget.e601Data.pernm);
    _etemtelnum       =  TextEditingController(text: widget.e601Data.emtelnum);
  }

  @override
  void dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext buildContext){
    return Scaffold(
      endDrawer: Nav_right(text: Text('app03_nav'),
        color: SOFT_BLUE,),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,

        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text('보수현장상세조회',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: _etactnm,
            readOnly: true,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '보수현장 *',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etequpnm,
            readOnly: true,
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '관리 호기명',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etelno,
            readOnly: true,
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '승강기번호',
                labelStyle:
                TextStyle(color: Colors.lightBlue)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etactaddr,
            readOnly: true,
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '보수현장 주소',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          Text('연락처'),
          TextButton(onPressed: () async {
            final url = Uri.parse('tel:' + _ettel.text);
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            } else {
              // ignore: avoid_print
              print("Can't launch $url");
            }
          }, child: Text(_ettel.text, style: GlobalStyle.couponName,),
            style: ButtonStyle(
              alignment: Alignment.centerLeft,

            ),
          ),
          /*TextField(
            controller: _ettel,
            readOnly: true,
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '연락처',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),*/

          /*TextField(
            controller: _ethp,
            readOnly: true,
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '핸드폰번호',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),*/
          Text('핸드폰번호'),
          TextButton(onPressed: () async {
            final url = Uri.parse('tel:' + _ethp.text);
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            } else {
              // ignore: avoid_print
              print("Can't launch $url");
            }
          }, child: Text(_ethp.text, style: GlobalStyle.couponName,),
            style: ButtonStyle(
              alignment: Alignment.centerLeft,

            ),
          ),

          TextField(
            controller: _etpernm,
            readOnly: true,
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '담당자',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          Text('비상연락망'),
          TextButton(onPressed: () async {
            final url = Uri.parse('tel:' + _etemtelnum.text);
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            } else {
              // ignore: avoid_print
              print("Can't launch $url");
            }
          }, child: Text(_etemtelnum.text, style: GlobalStyle.couponName,),
            style: ButtonStyle(
              alignment: Alignment.centerLeft,

            ),
          ),

        ],
      ),
    );
  }
}