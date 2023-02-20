import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class MhmanualList_model{
  late var custcd;
  late var spjangcd;
  late var hseq;
  late var hinputdate;
  late var hgroupcd;
  late var hsubject;
  late var hpernm;
  late var hmemo;
  late var hflag;
  late var attcnt;


  MhmanualList_model({  required this.custcd, required this.spjangcd ,required this.hseq, required this.hinputdate,
    required this.hgroupcd,required this.hsubject, required this.hpernm,required this.hmemo,required this.hflag,
    required this.attcnt

 });
}


List<MhmanualList_model> MhData =[];

// late var hfilename;
// late var yyyymm;
// late var cnam;
// late int attcnt; //int임
// required this.yyyymm,required this.cnam,required this.attcnt, required this.hfilename,required this.remark,
