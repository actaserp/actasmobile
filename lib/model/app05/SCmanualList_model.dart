import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class SCmanualList_model{
  late var custcd;
  late var spjangcd;
  late var sseq;
  late var sinputdate;
  late var spernm;
  late var smemo;
  late var sflag;
  late var subkey;


  SCmanualList_model({  required this.custcd, required this.spjangcd ,
    required this.sseq, required this.sinputdate,
    required this.spernm,required this.smemo, required this.sflag, required this.subkey
 });
}


List<SCmanualList_model> SCData =[];
List<SCmanualList_model> SCmData =[];
List<SCmanualList_model> keyData =[];
List<SCmanualList_model> SCpermData =[];
List<SCmanualList_model> inData =[];
