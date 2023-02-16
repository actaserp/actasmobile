import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class EmanualList_model{
  late var custcd;
  late var spjangcd;

  //공통 회사코드, 사업장코드
  late var eseq;
  late var egroupcd;
  late var einputdate;
  late var esubject;
  late var efilename;
  late var epernm;
  late var ememo;
  late var eflag;

  late var attcnt;
  late var cnam;


  EmanualList_model({ required this.custcd,required this.spjangcd,required this.eseq,required this.einputdate,required this.egroupcd,required this.esubject,required this.efilename,
    required this.epernm,required this.ememo,required this.eflag, required this.attcnt,required this.cnam
  });
}


List<EmanualList_model> EData =[];