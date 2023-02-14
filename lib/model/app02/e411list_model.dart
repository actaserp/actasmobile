import 'package:http/http.dart' as http;

class e411list_model{
  late var actnm;
  late var compdate;
  late var contnm;
  late var contents;
  late var resunm;
  late var resuremark;
  late var recedate;
  late var recetime;
  late var pernm;
  late var greginm;
  late var reginm;
  late var remonm;
  late var remoremark;




  e411list_model({
    required this.actnm, required this.compdate, required this.contnm, required this.contents, required this.resunm, required this.resuremark, this.recedate,
    this.recetime, required this.pernm, required this.greginm, required this.reginm, required this.remonm, required this.remoremark,
});




}

List<e411list_model> e411Data = [];