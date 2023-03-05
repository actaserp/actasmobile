class e401recelist_model{


  late var recedate;
  late var recedateyear;
  late var hitchdate;
  late var recetime;
  late var hitchhour;
  late var recenum;
  late var cltcd;

  late var actcd;
  late var actnm;
  late var equpcd;
  late var equpnm;
  late var actpernm;
  late var contcd;
  late var contnm;
  late var tel;
  late var reperid;
  late var repernm;
  late var perid;
  late var pernm;

  late var handphone;
  late var contents;
  late var addrtxt;

  e401recelist_model({
   required this.recedate, this.recedateyear, required this.hitchdate, this.recetime, this.hitchhour, this.recenum, this.actcd, required this.actnm,
    this.equpcd, this.equpnm, this.actpernm, this.contcd, this.contnm, this.tel, this.reperid, this.repernm, this.perid, this.pernm,
    this.handphone, this.contents, this.addrtxt, this.cltcd

});
}

List<e401recelist_model> e401receData = [];