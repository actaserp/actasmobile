import 'package:http/http.dart' as http;

class tbe601list_model{

  late var elno;
  late var equpnm;
  late var actnm;
  late var actaddr;
  late var tel;
  late var hp;
  late var pernm;
  late var emtelnum;



  tbe601list_model({
      this.elno,  this.equpnm,  this.actnm,  this.actaddr, this.tel, this.hp,  this.pernm,  this.emtelnum,
});



}

List<tbe601list_model> e601Data = [];
