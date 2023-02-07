import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class eresultnm_model{
  late var resultcd;
  late var resultnm;

  eresultnm_model({ required this.resultcd, required this.resultnm }){}


}


List<eresultnm_model> eResultData =[];
// Map  eContData ={};
