
import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class tbe047list_model{
  late var custcd;
  late var spjangcd;

  //공통 회사코드, 사업장코드
  late var carnum;
  late var carcd;
  late var pernm;

  tbe047list_model({ required this.custcd,required this.spjangcd,required this.carnum, required this.carcd,required this.pernm
  });
}


List<tbe047list_model> E047Data =[];
