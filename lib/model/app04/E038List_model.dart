
import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class E038List_model{
  late var custcd;
  late var spjangcd;

  late var rptdate;
  late var perid;
  late var rptnum;
  late var wkcd;
  late var actcd;
  late var actnm;
  late var frtime;
  late var totime;
  late var carcd;
  late var carnum;
  late var remark;
  late var filenum;
  late var equpcd;
  late var startkm;
  late var endkm;
  late var km;
  late var cltcd;
  late var pernm;
  late var equpnm;

  E038List_model({ required this.custcd,required this.spjangcd,required this.rptdate,required this.perid,required this.rptnum,
  required this.wkcd,required this.actcd,required this.actnm,required this.frtime,required this.totime,required this.carcd,required this.carnum,
  required this.remark,required this.filenum,required this.equpcd,required this.startkm,required this.endkm,required this.km,required this.cltcd,
  required this.pernm, required this.equpnm
});
}


List<E038List_model> e038Data =[];
