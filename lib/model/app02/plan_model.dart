class plan_model{

  late var custcd;
  late var spjangcd;
  late var plandate;
  late var cltcd;
  late var actcd;
  late var actnm;
  late var equpcd;
  late var equpnm;
  late var perid;
  late var pernm;
  late var remark;
  late var kcpernm;
  late var kcspnm;
  late var indate;
  late var qty;

  plan_model({
    this.custcd, this.spjangcd, required this.plandate, this.cltcd, required this.actcd, this.actnm, this.equpcd, this.equpnm,
    this.perid, this.pernm, this.remark, this.kcpernm, this.kcspnm, this.indate, this.qty
});
}

List<plan_model> planData =[];