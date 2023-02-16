class tbe401list_model{

  late var recedate;
  late var compdate;
  late var actnm;
  late var equpnm;
  late var hitchdate;
  late var indate;
  late var contnm;
  late var contents;
  late var greginm;
  late var reginm;
  late var remonm;
  late var remoremark;
  late var resunm;


  tbe401list_model({
    required this.actnm, this.recedate, this.compdate, this.equpnm, this.hitchdate, this.indate, required this.contents, required this.contnm
    ,this.greginm, this.reginm, this.remonm, this.remoremark, this.resunm
});

}

List<tbe401list_model> tbe401Data = [];
