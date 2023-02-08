import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class Comm751_model{
  late var code;
  late var cnam;

  Comm751_model({ required this.code, required this.cnam }){}

}

List<Comm751_model> C751Data =[];

//
// <select id="GetComm751List"  resultType="com.actas.ems.DTO.CommonDto">
// <![CDATA[
// SELECT  com_code AS code, com_cnam AS cnam
// FROM     dbo.tb_ca510 WITH (NOLOCK)
// WHERE  (com_cls = '751') AND (com_code <> '00')
// ]]>
// </select>