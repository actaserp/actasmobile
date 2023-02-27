import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class e401list_model{
  late var remark; //고객요망사항
  late var contents;
  late var actperid;
  late var perid;
  late var frdate;
  late var todate;
  late var recedate; //접수일자
  late var recenum; //접수번호
  late var recetime;
  late var actcd;
  late var actnm;
  late var equpcd;
  late var equpnm; //호기명
  late var actpernm;
  late var pernm;
  late var contcd;
  late var contnm;
  late var contremark;
  late var resuremark;
  late var resultcd;
  late var resucd;
  late var regicd;
  late var gregicd;
  late var compdate;
  late var comptime;
  late var remocd;
  late var cltcd;
  late var divicd;
  late var arrivetime;




  e401list_model({ required this.remark,required this.contents,required this.actperid,required this.perid,required this.frdate,required this.todate,required this.recedate,
    required this.recenum,required this.recetime, required this.actcd,required this.actnm,required this.equpcd,required this.equpnm,
    required this.actpernm,required this.pernm,required this.contcd, required this.contnm,required this.contremark, this.resuremark, this.resultcd, this.resucd,
    this.regicd, this.gregicd , this.compdate, this.comptime, required this.remocd, this.cltcd, this.divicd, this.arrivetime});





}


List<e401list_model> e401Data =[];
