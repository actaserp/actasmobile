
import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class MmanualList_model{
  late var custcd;
  late var spjangcd;

  //공통 회사코드, 사업장코드
  late var mseq;
  late var mgroupcd;
  late var minputdate;
  late var msubject;
  late var mfilename;
  late var mpernm;
  late var mmemo;
  late var mflag;

  late var attcnt;
  late var cnam;


  MmanualList_model({ required this.custcd,required this.spjangcd,required this.mseq,required this.minputdate,required this.mgroupcd,required this.msubject,required this.mfilename,
    required this.mpernm,required this.mmemo,required this.mflag, required this.attcnt, required this.cnam
  });
}


List<MmanualList_model> MData =[];
