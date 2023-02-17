import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class AttachList_model{
  late var idx;
  late var boardIdx;
  late var originalName;
  late var saveName;
  late var size;
  late var flag;
  late var deleteyn;
  late var inserttime;
  late var deletetime;



  AttachList_model({  required this.idx, required this.boardIdx ,
    required this.originalName, required this.saveName,
    required this.size,required this.flag, required this.deleteyn,
    required this.inserttime, required this.deletetime
 });
}


List<AttachList_model> ATCData =[];