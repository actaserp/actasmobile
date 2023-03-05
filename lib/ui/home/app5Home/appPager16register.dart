import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/app02/e401recelist_model.dart';
import '../../../model/app02/e401recelist_model.dart';
import '../app03/Nav_right.dart';

class AppPager16register extends StatefulWidget {


  // final MhmanualList_model mhData;
  // const AppPage03Detail({Key? key, required this.mhData}) : super(key: key);

  @override
  _AppPager16registerState createState() => _AppPager16registerState();
}
class _AppPager16registerState extends State<AppPager16register> {

  late String _hour, _minute, _time;
  String _erecetime = '';
  String _ehitchtime = '';
  String actcd = "";
  String actnm = "";
  String cltcd = "";
  String equpcd = "";
  String equpnm = "";
  String recenum = "";
  String recedate2 = "";


  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();

  final List<String> _eContData = [];

  String? _etContcdTxt;

  TextEditingController _etrecedate = TextEditingController();
  TextEditingController _etrecetime = TextEditingController();
  TextEditingController _ethitchdate = TextEditingController();
  TextEditingController _ethitchtime = TextEditingController();
  TextEditingController _etactnm = TextEditingController();
  TextEditingController _etequpnm = TextEditingController();
  TextEditingController _etcontnm = TextEditingController();
  TextEditingController _etcontents = TextEditingController();
  TextEditingController _etactpernm = TextEditingController();
  TextEditingController _ettel = TextEditingController();
  TextEditingController _etaddrtxt = TextEditingController();
  TextEditingController _etremark = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
        title: Text('고장접수등록',
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
                width: MediaQuery.of(context).size.width * 0.432,
                child: TextField(
                  controller: _etrecedate,
                  readOnly: true,
                  onTap: () {
                    _selectDateWithMinMaxDate(context);
                  },
                  maxLines: 1,
                  cursorColor: Colors.grey[600],
                  style: TextStyle(fontSize: 16, color: Colors.lightBlue[700]),
                  decoration: InputDecoration(
                      isDense: true,
                      suffixIcon: Icon(Icons.date_range, color: Colors.pinkAccent),
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
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 0.381,
                child: TextField(
                  controller: _etrecetime,
                  readOnly: true,
                  onTap: () {
                    /*_selectTime(context);*/
                  },
                  maxLines: 1,
                  cursorColor: Colors.grey[600],
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  decoration: InputDecoration(
                      isDense: true,
                      suffixIcon: Icon(Icons.date_range, color: Colors.pinkAccent),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      labelText: '접수시간 *',
                      labelStyle:
                      TextStyle(color: BLACK_GREY)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> _selectDateWithMinMaxDate(BuildContext context) async {
    var firstDate = DateTime(initialDate.year, initialDate.month - 3, initialDate.day);
    var lastDate = DateTime(initialDate.year, initialDate.month, initialDate.day + 60);
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



        _etrecedate = TextEditingController(
            text: _selectedDate.toLocal().toString().split(' ')[0]);

      });
    }
  }

  Future<Null> _selectDateWithMinMaxDate2(BuildContext context) async {
    var firstDate = DateTime(initialDate.year, initialDate.month - 3, initialDate.day);
    var lastDate = DateTime(initialDate.year, initialDate.month, initialDate.day + 60);
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



        _ethitchdate = TextEditingController(
            text: _selectedDate.toLocal().toString().split(' ')[0]);

      });
    }
  }

/*

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _etrecetime.text = _time;
        _erecetime = _hour  + _minute;
        widget.e401receData.recetime  = _hour  + _minute;
        _erecetime =  _hour  + _minute;
        _etrecetime.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        widget.e401receData.recetime = _etrecetime.text.toString();
      });
  }


  Future<Null> _selectTime2(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _ethitchtime.text = _time;
        _ehitchtime = _hour  + _minute;
        widget.e401receData.hitchhour  = _hour  + _minute;
        _ehitchtime =  _hour  + _minute;
        _ethitchtime.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        widget.e401receData.hitchhour = _ethitchtime.text.toString();
      });
  }*/

}