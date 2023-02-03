import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/constant.dart';


class e401list_model{
  late var remark; //고객요망사항
  late var contents;
  late var actperid;
  late var perid;
  late var frdate;
  late var todate;
  late var recedate; //접수일자
  late var recenum; //접수번호
  late var recetime;
  late var actcd;
  late var actnm;
  late var equpcd;
  late var equpnm; //호기명
  late var actpernm;
  late var pernm;
  late var contcd;
  late var contnm;
  late var contremark;

  e401list_model({ required this.remark,required this.contents,required this.actperid,required this.perid,required this.frdate,required this.todate,required this.recedate,
    required this.recenum,required this.recetime, required this.actcd,required this.actnm,required this.equpcd,required this.equpnm,
    required this.actpernm,required this.pernm,required this.contcd, required this.contnm,required this.contremark });


  // factory e401list_model.fromJson(Map<String, dynamic> json) {
  //   return e401list_model(
  //     remark: json['remark'],
  //     contents: json['contents'],
  //     actperid: json['actperid'],
  //     perid: json['perid'],
  //     frdate: json['frdate'],
  //     todate: json['todate'],
  //     recedate: json['recedate'],
  //     recenum: json['recenum'],
  //     recetime: json['recetime'],
  //     actcd: json['actcd'],
  //     actnm: json['actnm'],
  //     equpcd: json['equpcd'],
  //     equpnm: json['equpnm'],
  //     actpernm: json['actpernm'],
  //     pernm: json['pernm'],
  //     contcd: json['contcd'],
  //     contnm: json['contnm'],
  //     contremark: json['contremark'],
  //   );
  // }
}


List<e401list_model> e401Data =[];

// List<E401listModel> couponData =[
//   E401listModel(
//       id: 1,
//       name: 'FASHION50',
//       day: '2',
//       term: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque tortor tortor, ultrices id scelerisque a, elementum id elit. Maecenas feugiat tellus sed augue malesuada, id tempus ex sodales. Nulla at cursus eros. Integer porttitor ac ipsum quis sollicitudin. Sed mollis sapien massa, et dignissim turpis vulputate et. Ut ac odio porta, blandit velit in, pharetra lacus. Integer aliquam dolor nec augue porttitor hendrerit. Vestibulum aliquam urna finibus, luctus felis nec, hendrerit augue. Fusce eget lacinia leo. Vivamus porttitor, lacus eget rutrum tempus, odio magna tincidunt elit, ut vulputate nibh velit eu lectus. Morbi felis mi, efficitur sed diam in, elementum ullamcorper leo. Ut bibendum lorem consectetur pellentesque gravida. Sed est orci, consectetur id nunc quis, volutpat consectetur nisi.\n\n'+
//           'Donec est neque, accumsan sit amet imperdiet porta, suscipit eu ex. Phasellus lobortis mollis pharetra. Donec maximus rhoncus elit, sed pellentesque justo pretium vel. Integer vitae facilisis lectus. Suspendisse potenti. Mauris iaculis placerat feugiat. Integer commodo dui sit amet finibus congue. Nulla egestas lacus vel elit aliquet, at pulvinar ex venenatis. Vivamus eget maximus libero, quis vulputate diam. Pellentesque vel justo vel lectus viverra aliquet ut eget metus.\n\n'+
//           'Vivamus malesuada velit pretium laoreet pulvinar. Duis non dignissim sapien, vitae viverra purus. Curabitur a gravida mauris. Nullam turpis odio, ultricies sed ultricies non, sodales eget purus. Donec pulvinar bibendum metus vitae ornare. Phasellus eleifend orci eget blandit sollicitudin. Sed sed urna in magna dignissim eleifend.\n\n'+
//           'Vestibulum vitae erat maximus, laoreet ex quis, laoreet nunc. Sed porttitor massa eget cursus rhoncus. Suspendisse et tellus et enim ullamcorper semper eget in nisl. Nam metus mauris, sollicitudin in venenatis at, pretium at nulla. Sed a accumsan dui. Quisque fermentum mollis erat, ac fringilla eros auctor eu. Donec placerat mi ut sem ullamcorper tempor. Pellentesque ut nulla sollicitudin, tempus arcu quis, vulputate dolor. Sed ultrices cursus nisl, nec tempor neque tempus at. Pellentesque nec dolor faucibus, porttitor quam sed, vehicula est. Vestibulum placerat placerat neque eu posuere. Pellentesque id mauris hendrerit, placerat lacus id, auctor eros. Praesent vestibulum mattis est, non facilisis urna accumsan et. Vestibulum scelerisque ornare sapien, nec blandit purus rhoncus mollis. Sed faucibus, augue consequat rhoncus rutrum, sapien mauris dictum quam, nec tempus orci urna vitae lorem. Curabitur sit amet nisl et lacus fringilla pulvinar.'
//   ),
// ];