
import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class DmanualList_model{
  late var custcd;
  late var spjangcd;

  //공통 회사코드, 사업장코드
  late var dseq;
  late var dgroupcd;
  late var dinputdate;
  late var dsubject;
  late var dfilename;
  late var dpernm;
  late var dmemo;
  late var dflag;

  late var attcnt;
  late var cnam;


  DmanualList_model({ required this.custcd,required this.spjangcd,required this.dseq,required this.dinputdate,required this.dgroupcd,required this.dsubject,required this.dfilename,
    required this.dpernm,required this.dmemo,required this.dflag, required this.attcnt, required this.cnam
  });
}


List<DmanualList_model> DData =[];
