import 'package:http/http.dart' as http;

class e411list_model{
  late var compyear;
  late var actnm;
  late var equpcd;
  late var equpnm;
  late var greginm;
  late var gregicd;
  late var reginm;
  late var result;
  late var mon01;
  late var mon02;
  late var mon03;
  late var mon04;
  late var mon05;
  late var mon06;
  late var mon07;
  late var mon08;
  late var mon09;
  late var mon10;
  late var mon11;
  late var mon12;
  late var frdate;
  late var todate;


  e411list_model({
    required this.compyear, required this.actnm, required this.equpcd, required this.equpnm, required this.greginm, required this.gregicd,
    required this.reginm, this.result, this.mon01,this.mon02,this.mon03,this.mon04,this.mon05,this.mon06,this.mon07,this.mon08,this.mon09,this.mon10,
    this.mon11, this.mon12, required this.frdate, required this.todate
});




}

List<e411list_model> e411Data = [];