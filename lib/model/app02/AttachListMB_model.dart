class AttachListMB_model{

  late var idx;
  late var boardIdx;
  late var originalName;
  late var saveName;
  late var size;
  late var flag;
  late var deleteyn;
  late var inserttime;
  late var deletetime;



  AttachListMB_model({
    required this.idx, required this.boardIdx ,
    required this.originalName, required this.saveName,
    required this.size,required this.flag, required this.deleteyn,
    required this.inserttime, required this.deletetime
});

}

List<AttachListMB_model> ATCData_MB = [];
List<AttachListMB_model> idxData_MB =[];
List<AttachListMB_model> seqData_MB =[];