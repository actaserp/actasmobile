class mfixlist_model{


  late var fseq;

  late var finputdate;
  late var fnsubject;
  late var fpernm;
  late var fmemo;
  late var fgourpcd;
  late var cnam;
  late var fflag;
  late var attcnt;





  mfixlist_model({
    required this.fseq, required this.finputdate, required this.fnsubject, this.fmemo, this.fpernm,
    this.fgourpcd, this.cnam, this.fflag, this.attcnt
});
}


List<mfixlist_model> mfixData = [];
