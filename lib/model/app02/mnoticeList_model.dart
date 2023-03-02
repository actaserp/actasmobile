class mnoticeList_model{

  late var nseq;
  late var ninputdate;
  late var ngourpcd;
  late var nsubject;
  late var npernm;
  late var nmemo;
  late var nflag;
  late var cnam;
  late var attcnt;


  mnoticeList_model({
    required this.nseq, required this.ninputdate, required this.ngourpcd, required this.nsubject, required this.npernm, required this.nmemo,
    required this.nflag, required this.cnam, this.attcnt,
});


}

List<mnoticeList_model> mnoticeData = [];