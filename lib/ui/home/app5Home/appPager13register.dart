import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:actasm/ui/home/app5Home/appPager13.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/shopping_cart_model.dart';
import '../../reusable/cache_image_network.dart';
import '../../reusable/reusable_widget.dart';

class AppPager13register extends StatefulWidget {

  @override
  _AppPager13registerState createState() => _AppPager13registerState();
}
class _AppPager13registerState extends State<AppPager13register> {


  final List<String> _C750Data = [];
  final _reusableWidget = ReusableWidget();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();



  int _maxgoodParts = 2;
  final List<String> _eGregiData = [];
  List<String> dropdownList = ['합격', '불합격', '조건부'];
  String _selectedValue = "";
  String ? _selectedValue2;
  var _usernm = "";

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

  FormData formData = FormData();





  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();
  late String now;
  late String now2;
  final dio = Dio();
  String _dbnm = '';
  String? _etGregicdTxt;
  String usernm = "";
  TextEditingController _memo = TextEditingController();
  TextEditingController _subject = TextEditingController();

  TextEditingController _etCompdate = TextEditingController();




  TextEditingController _etfintputdate = TextEditingController();



  @override
  void initState() {

    super.initState();
    initData();
    _selectedValue2 = "합격";
    _selectedValue = "001";
    print(_selectedValue);
    print("object!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    _etfintputdate.text = DateTime.now().toString().substring(0,10);
    /* now = DateTime.now().toString();
    now2 = now.substring(0,10);

    _etfintputdate = TextEditingController(text: now2);*/
  }

  @override

  ///저장시 setData
  Future<void> initData() async {
    await sessionData();
    setData();
    _selectedValue = "001";
  }
  Future<void> sessionData() async {
    String username = await SessionManager().get("username");
    // 문자열 디코딩
    setState(() {
      _usernm = utf8.decode(username.runes.toList());
    });
  }

  void setData() {
    // 다른 데이터 설정
  }



  Future<void> _pickImg() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if(images != null){
      setState(() {
        _pickedImgs = images;
      });
    }

  }






  //저장
  @override
  Future<bool> save_mhdata() async {






    /*for (int i = 0; i < _pickedImgs.length; i++) {
      var pic = await MultipartFile.fromFile(_pickedImgs[i].path,
          contentType: new MediaType("image", "jpg"));
      multipartImgList.add(pic);
    }*/

/*
    var formData = FormData.fromMap({
      for (int i = 0; i < multipartImgList.length; i++)
        'file': multipartImgList[i]
    });
*/

    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/apppgymobile/mfixbbssave';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");
    ///null처리
    if(_etfintputdate.text == "") {
      showAlertDialog(context, '작성일자를 입력하세요');

      return false;
    }
    if(_subject.text.isEmpty || _subject.text == "") {
      showAlertDialog(context, '제목을 입력하세요');
      return false;
    }
    if(_memo.text.isEmpty || _memo.text == "" ) {
      showAlertDialog(context, '내용을 입력하세요');
      return false;
    }
    if(_selectedValue.isEmpty || _selectedValue == "" ) {
      showAlertDialog(context, '분류를 선택하세요');
      return false;
    }



    final List<MultipartFile> _files = _pickedImgs.map((img) => MultipartFile.fromFileSync(img.path, contentType: MediaType("image", "jpg"))).toList();
    formData = FormData.fromMap({"file" : _files});


    formData.fields.add(MapEntry('dbnm', _dbnm));
    formData.fields.add(MapEntry('fseq', ""));
    formData.fields.add(MapEntry('finputdate', _etfintputdate.text));
    formData.fields.add(MapEntry('fpernm', _usernm.toString()));
    formData.fields.add(MapEntry('fmemo', _memo.text));
    formData.fields.add(MapEntry('fnsubject', _subject.text));
    formData.fields.add(MapEntry('fgroupcd', _selectedValue));
    formData.fields.add(MapEntry('fflag', 'Y'));

    dio.options.contentType = 'multipart/form-data';

    final response = await dio.postUri(uri,
    data: formData
    );


    /*final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'fseq': "",
        ///저장시 필수 값 //작성된 groupcd랑 이름
        ///custcd, spjangcd, hseq 컨트롤러
        'finputdate': _etfintputdate.text,
        'fpernm': _usernm.toString(),
        'fmemo': _memo.text,
        'fnsubject': _subject.text,
        'fgroupcd': _selectedValue,
        'fflag': 'Y'
      },
    );*/

    if(response.statusCode == 200){
      print("저장됨");
      return   true;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('수리노하우 저장에 실패했습니다');
      return   false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context){

    List<Widget> _boxContents = [
      IconButton(onPressed: (){
          _pickImg();
      }, icon: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6), shape: BoxShape.circle
        ),
        child: Icon(CupertinoIcons.camera, color: Colors.green,),
      )),
      Container(),
      Container(),
      _pickedImgs.length <= 4 ? Container() : FittedBox(child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          shape: BoxShape.circle
        ),
        child: Text(
          '+${(_pickedImgs.length - 4).toString()}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),)
    ];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text(
          '점검조치사항 등록',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        bottom: _reusableWidget.bottomAppBar(),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            color: SOFT_BLUE,
            elevation: 5,
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(

                  icon: Icon(Icons.keyboard_arrow_down),
                  dropdownColor: SOFT_BLUE,
                  iconEnabledColor: Colors.white,
                  /*hint: Text("합격",  style: TextStyle(color: Colors.white)),*/
                  items: dropdownList.map((item) {
                    return DropdownMenuItem<String>(
                      child: Text(item, style: TextStyle(color: Colors.white)),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (String? value) =>
                      setState(() {
                        if(value.toString() == "합격"){
                          _selectedValue = "001";
                        }

                        if(value.toString() == "불합격"){
                          _selectedValue = "002";
                        }

                        if(value.toString() == "조건부"){
                          _selectedValue = "003";
                        }
                        this._selectedValue2 = value;
                        print(_selectedValue);
                      }),
                  value: _selectedValue2,

                ),
              ),
            ),

          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etfintputdate,
            readOnly: true,
            onTap: () {
              _selectDateWithMinMaxDate(context);
            },
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                suffixIcon: Icon(Icons.date_range, color: Colors.pinkAccent),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '작성일자 ',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              _usernm == null ? Container() :
              Row(
                children: [
                  Text( _usernm,
                    style: TextStyle(color: SOFT_BLUE ,fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                  Text( '님이 작성 중입니다.',
                    style: TextStyle(color: BLACK_GREY ,fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _subject,
              validator: (value){
                if(value != null  && value.isEmpty){
                  return '값을 입력하세요';

                }
                return null;
              },
              autofocus: true,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '제목을 작성하세요',
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: '제목 *',
                  labelStyle:
                  TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),

            ),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey2,
            child: TextFormField(
              autofocus: true,
              controller: _memo,
              validator: (value){
                if(value != null  && value.isEmpty){
                  return '내용을 입력하세요';

                }
                return null;
              },
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '내용을 작성하세요',
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: '내용 *',
                  labelStyle:
                  TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => SOFT_BLUE,
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      )
                  ),
                ),
                onPressed: ()  async {
                  if(_formKey.currentState!.validate() && _formKey2.currentState!.validate()){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        content: Text('저장하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () async {

                              if(_formKey.currentState!.validate()){
                                Navigator.pop(context);
                                await save_mhdata();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppPager13()));
                              }



                              /* Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => AppPager13()),
                            );
                            Get.off(AppPager14());*/
                            },
                          ),
                          TextButton(onPressed: (){
                            Navigator.pop(context, "취소");
                          }, child: Text('Cancael')),

                        ],
                      );
                    });
                  }
                  /*_reusableWidget.startLoading(context, '등록 되었습니다.', 1);*/
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    '등록하기',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
            ),
          ),
          SizedBox(
            height: 350,
            child: GridView.count(
              padding: EdgeInsets.all(2),
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: List.generate(4, (index) => DottedBorder(child: Container(
                child: Center(child: _boxContents[index]),
                decoration: index <= _pickedImgs.length - 1 ? BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(fit: BoxFit.cover, image: FileImage(File(_pickedImgs[index].path)))
                ) : null,
              ),
              color: Colors.grey, dashPattern: [5, 3], borderType: BorderType.RRect, radius: Radius.circular(10))).toList(),
            ),
          )

        ],
      ),

    );
  }





  Future<Null> _selectDateWithMinMaxDate(BuildContext context) async {
    var firstDate = DateTime(initialDate.year, initialDate.month - 3, initialDate.day);
    var lastDate = DateTime(initialDate.year, initialDate.month, initialDate.day + 60);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.pinkAccent,
            colorScheme: ColorScheme.light(primary: Colors.pinkAccent, secondary: Colors.pinkAccent),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;

        _etfintputdate = TextEditingController(
            text: _selectedDate.toLocal().toString().split(' ')[0]);
      });
    }
  }




  //저장시 confirm
  void showAlertDialog(BuildContext context, String as_msg) async {

    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('점검조치등록'),
          content: Text(as_msg),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "확인");
              },
            ),
          ],
        );
      },
    );
  }


}