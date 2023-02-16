
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/tbe401list_model.dart';

class AppPager12Detail extends StatefulWidget{

  final tbe401list_model tbe401Data;

  const AppPager12Detail({Key? key, required this.tbe401Data}) : super(key: key);


  @override
  _AppPager12DetailState createState() => _AppPager12DetailState();

}

class _AppPager12DetailState extends State<AppPager12Detail> {

  TextEditingController _etrecedate     = TextEditingController();
  TextEditingController _etcompdate     = TextEditingController();
  TextEditingController _etactnm        = TextEditingController();
  TextEditingController _etequpnm       = TextEditingController();
  TextEditingController _ethitchdate    = TextEditingController();
  TextEditingController _etindate       = TextEditingController();
  TextEditingController _etcontnm       = TextEditingController();
  TextEditingController _etcontents     = TextEditingController();
  TextEditingController _etgreginm      = TextEditingController();
  TextEditingController _ereginm        = TextEditingController();
  TextEditingController _etremonm       = TextEditingController();
  TextEditingController _etremoremark   = TextEditingController();
  TextEditingController _etresunm       = TextEditingController();





  @override
  void initState() {

    setData();
    super.initState();
  }

  @override
  void setData(){
    _etrecedate       = TextEditingController(text: widget.tbe401Data.recedate);
    _etcompdate       = TextEditingController(text: widget.tbe401Data.compdate);
    _etactnm       = TextEditingController(text: widget.tbe401Data.actnm);
    _etequpnm       = TextEditingController(text: widget.tbe401Data.equpnm);
    _ethitchdate       = TextEditingController(text: widget.tbe401Data.hitchdate);
    _etindate       = TextEditingController(text: widget.tbe401Data.indate);
    _etcontnm       = TextEditingController(text: widget.tbe401Data.contnm);
    _etcontents       = TextEditingController(text: widget.tbe401Data.contents);
    _etgreginm       = TextEditingController(text: widget.tbe401Data.greginm);
    _ereginm       = TextEditingController(text: widget.tbe401Data.reginm);
    _etremonm       = TextEditingController(text: widget.tbe401Data.remonm);
    _etremoremark       = TextEditingController(text: widget.tbe401Data.remoremark);
    _etresunm       = TextEditingController(text: widget.tbe401Data.resunm);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,

        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text('고장이력조회',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Container(
                width: 150 * scaleWidth(context),
                child: TextField(
                  controller: _etrecedate,
                  readOnly: true,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue),
                      ),
                      labelText: '접수일자 *',
                      labelStyle:
                      TextStyle(color: BLACK_GREY)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                width: 150 * scaleWidth(context),
                child: TextField(
                  controller: _etcompdate,
                  readOnly: true,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue),
                      ),
                      labelText: '처리일자 *',
                      labelStyle:
                      TextStyle(color: BLACK_GREY)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etactnm,
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
                labelText: '보수현장',
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
                labelText: '동호기명',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: 150 * scaleWidth(context),
                child: TextField(
                  controller: _ethitchdate,
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
                      labelText: '고장일자',
                      labelStyle:
                      TextStyle(color: BLACK_GREY)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                width: 150 * scaleWidth(context),
                child: TextField(
                  controller: _etindate,
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
                      labelText: '입력일자',
                      labelStyle:
                      TextStyle(color: BLACK_GREY)),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etcontnm,
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
                labelText: '고장내용',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etcontents,
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
                labelText: '고장상세내용',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etgreginm,
            readOnly: true,
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.black),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[800]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[800]!),
                ),
                labelText: '고장부위',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etremonm,
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
                labelText: '고장요인',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etremoremark,
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
                labelText: '고장요인상세',
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
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '처리방법',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
        ],
      ),
    );
  }

  static double scaleWidth(BuildContext context){
    const designWidth = 393;
    final diff =  designWidth /getDeviceWidth(context) ;
    return diff;
  }

  static getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }


}