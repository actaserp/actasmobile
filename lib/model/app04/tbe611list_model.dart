
import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class tbe611list_model{
  late var custcd;
  late var spjangcd;

  //공통 회사코드, 사업장코드
  late var cltcd;
  late var actnm;
  late var equpcd;
  late var equpnm;


  tbe611list_model({ required this.custcd,required this.spjangcd,required this.cltcd, required this.actnm,required this.equpnm, required this.equpcd
  });
}


List<tbe611list_model> E611Data =[];
