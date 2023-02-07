import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class econtnm_model{
  late var contcd;
  late var contnm;

  econtnm_model({ required this.contcd, required this.contnm }){}


}


List<econtnm_model> eContData =[];
// Map  eContData ={};
