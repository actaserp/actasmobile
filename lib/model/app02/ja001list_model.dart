import 'package:http/http.dart' as http;

class ja001list_model{

  late var pernm;
  late var divinm;
  late var rspnm;
  late var handphone;



  ja001list_model({
    required this.pernm, required this.divinm, this.rspnm, required this.handphone,
});

}

List<ja001list_model> ja001Data = [];
