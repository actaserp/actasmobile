import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/e411list_model.dart';
import '../app03/Nav_right.dart';

class AppPager08Detail extends StatefulWidget{

  final e411list_model e411Data;

  const AppPager08Detail({Key? key, required this.e411Data}) : super(key: key);


  @override
  _AppPager08DetailState createState() => _AppPager08DetailState();

}

class _AppPager08DetailState extends State<AppPager08Detail> {

  TextEditingController _etActnm     = TextEditingController();
  TextEditingController _etGreginm    = TextEditingController();
  TextEditingController _etReginm  = TextEditingController();
  TextEditingController _etRecedate  = TextEditingController();
  TextEditingController _etresunm  = TextEditingController();
  TextEditingController _etresuremark  = TextEditingController();
  TextEditingController _etpernm  = TextEditingController();
  TextEditingController _etCompdate  = TextEditingController();

  @override
  void initState(){
    setData();
    super.initState();
  }

  @override
  void setData(){
    _etActnm = TextEditingController(text: widget.e411Data.actnm);
    _etGreginm = TextEditingController(text: widget.e411Data.greginm);
    _etReginm = TextEditingController(text: widget.e411Data.reginm);
    _etRecedate = TextEditingController(text: widget.e411Data.recedate);
    _etresunm = TextEditingController(text: widget.e411Data.resunm);
    _etresuremark = TextEditingController(text: widget.e411Data.resuremark);
    _etpernm = TextEditingController(text: widget.e411Data.pernm);
    _etCompdate = TextEditingController(text: widget.e411Data.compdate);
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      endDrawer: Nav_right(text: Text('app03_nav'),
        color: SOFT_BLUE,),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,

        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text('고장부위상세조회',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: _etActnm,
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
            controller: _etGreginm,
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
                labelText: '고장부위',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etReginm,
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
                labelText: '고장부위상세',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etresunm,
            readOnly: true,
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.lightBlue[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '처리내용',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etresuremark,
            readOnly: true,
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.lightBlue[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '처리상세내용',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etRecedate,
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
                labelText: '접수일자',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etCompdate,
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
                labelText: '처리일자',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
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
                labelText: '처리자',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
        ],
      ),
    );
  }

}