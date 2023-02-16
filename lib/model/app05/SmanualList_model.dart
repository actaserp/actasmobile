import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class SmanualList_model{
  late var custcd;
  late var spjangcd;
  late var sseq;
  late var sinputdate;
  late var spernm;
  late var smemo;
  late var sflag;
  late var subkey;


  SmanualList_model({  required this.custcd, required this.spjangcd ,
    required this.sseq, required this.sinputdate,
    required this.spernm,required this.smemo, required this.sflag, required this.subkey
 });
}


List<SmanualList_model> SData =[];