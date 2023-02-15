import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class BmanualList_model{
  late var custcd;
  late var spjangcd;
  late var bseq;
  late var binputdate;
  late var bgourpcd;
  late var bsubject;
  late var bpernm;
  late var bmemo;
  late var bflag;


  BmanualList_model({  required this.custcd, required this.spjangcd ,
    required this.bseq, required this.binputdate,
    required this.bgourpcd,required this.bsubject,
    required this.bpernm,required this.bmemo, required this.bflag,

 });
}


List<BmanualList_model> BData =[];