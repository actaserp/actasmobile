import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class Comm754_model{
  late var code;
  late var cnam;

  Comm754_model({ required this.code, required this.cnam }){}

}

List<Comm754_model> C754Data =[];