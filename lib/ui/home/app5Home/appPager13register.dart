import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../../../model/shopping_cart_model.dart';
import '../../reusable/cache_image_network.dart';
import '../../reusable/reusable_widget.dart';

class AppPager13register extends StatefulWidget {


  // final MhmanualList_model mhData;
  // const AppPage03Detail({Key? key, required this.mhData}) : super(key: key);

  @override
  _AppPager13registerState createState() => _AppPager13registerState();
}
class _AppPager13registerState extends State<AppPager13register> {

  final List<String> _C750Data = [];
  final _reusableWidget = ReusableWidget();
  List<String> _goodParts = [];
  int _maxgoodParts = 2;
  final List<String> _eGregiData = [];
  List<String> dropdownList = ['합격', '불합격', '조건부'];
  String? _selectedValue = "";
  String _shared = "N";


  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  String _dbnm = '';
  String? _etGregicdTxt;
  String usernm = "";
  TextEditingController _mhCustcd = TextEditingController();
  TextEditingController _etAddressTitle = TextEditingController(text: 'Home Address');
  TextEditingController _etpernm = TextEditingController();
  TextEditingController _etState = TextEditingController(text: 'USA');
  TextEditingController _etCompdate = TextEditingController();




  @override
  void initState() {

    setData();
    super.initState();




  }

  Future<void> setData() async {

    usernm = await  SessionManager().get("username");

  }





  @override
  Future pop_Com750()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/Com750';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        'greginm': '%',
      },
    );

    if(response.statusCode == 200){
     /* List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      C751Data.clear();
      _C751Data.clear();
      for (int i = 0; i < alllist.length; i++) {
        if (alllist[i]['gregicd'] != null || alllist[i]['gregicd'].length > 0 ){
          Comm751_model emObject= Comm751_model(
              code:alllist[i]['code'],
              cnam:alllist[i]['cnam']
          );
          setState(() {
            C751Data.add(emObject);
            _C751Data.add(alllist[i]['code'] + '[' + alllist[i]['cnam'] + ']' );
          });
        }
      }

      return C751Data;*/
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('고장부위 불러오는데 실패했습니다');
    }
  }

  //저장
  @override
  Future<bool> save_mhdata()async {
    _dbnm = await  SessionManager().get("dbnm");
    var uritxt = CLOUD_URL + '/appmobile/saveeMh';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    print("----------------------------");
    //null처리
    // if(widget.e401Data.compdate == null  ) {
    //   showAlertDialog(context, "처리일자를 등록하세요");
    //   return false;
    // }
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'dbnm': _dbnm,
        // 'recedate': widget.e401Data.recedate.toString(),
        // 'recenum': widget.e401Data.recenum.toString(),
        // 'resuremark': widget.e401Data.resuremark.toString(),
        'custcd': _mhCustcd.toString(),
      },
    );
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
    setData();
    final double boxImageSize = (MediaQuery.of(context).size.width / 5);
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
                  hint: Text("분류",  style: TextStyle(color: Colors.white)),
                  items: dropdownList.map((item) {
                    return DropdownMenuItem<String>(
                      child: Text(item, style: TextStyle(color: Colors.white)),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (String? value){
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

                    });

                    print(_selectedValue);
                    /*C751Data.clear();
                    _C751Data.clear();
                    pop_Com751();*/
                  },
                ),
              ),
            ),

          ),
          SizedBox(
            height: 20,
          ),
          _buildOptioncheckParts(),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etCompdate,
            readOnly: false,
            onTap: () {
              // _selectDateWithMinMaxDate2(context);
            },
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
                isDense: true,
                hintText: '작성일자를 입력하세요',
                suffixIcon: Icon(Icons.date_range, color: Colors.pinkAccent),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '작성일자 *',
                labelStyle:
                TextStyle(fontSize: 16,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etState,
            decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
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
          SizedBox(
            height: 20,
          ),

          /*TextField(
            enabled: false,
            style: TextStyle(color: BLACK_GREY),
            controller: _etpernm,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(

                focusedBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                labelText: '작성자 *',
                labelStyle:
                TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),

  Future<void> setData() async {
    usernm = await  SessionManager().get("username");

  }
          ),*/
           Text(
            '작성자 :  ' + usernm,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etAddressTitle,
            decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
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
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(    //왼쪽 크기 정하기
                width: 0,
                height: 40,
              ),
              Text('첨부파일 목록', style: TextStyle(
                  fontSize: 16,
                  color: SOFT_BLUE,
                  fontWeight: FontWeight.bold
              ),
                  textAlign: TextAlign.center
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 500
              ),
              GestureDetector(
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => EAppPage03Detail()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: SOFT_BLUE,
                    border: Border.all(
                      color: SOFT_BLUE,
                    ),

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Text('업로드', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,
                    ),
                        textAlign: TextAlign.center
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            //텍스트 넣고 싶다 첨부파일자리라고 ㅠ
            child: Column(
              children: List.generate(shoppingCartData.length,(index){
                return _buildItem(index, boxImageSize);
              }),
            ),
          ),
          SizedBox(
            height: 40,
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
                onPressed: () {
                  /*_reusableWidget.startLoading(context, '등록 되었습니다.', 1);*/
                  print(usernm);
                  print("object");
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


        ],
      ),

    );
  }


  //  첨부파일리스트 ~ network로 가져와야함
  Column _buildItem(index, boxImageSize){
    int quantity = shoppingCartData[index].qty;
    return Column(
      children: [
        Container(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: (){

                  },
                  child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(4)),
                      child: buildCacheNetworkImage(width: boxImageSize, height: boxImageSize, url: shoppingCartData[index].image)),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){

                        },
                        child: Text(
                          shoppingCartData[index].name,
                          style: GlobalStyle.productName.copyWith(fontSize: 14),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        // child: Text('\$ '+_globalFunction.removeDecimalZeroFormat(shoppingCartData[index].price),
                        //     style: GlobalStyle.productPrice),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                // showPopupDelete(index, boxImageSize);
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1, color: Colors.grey[300]!)),
                                child: Icon(Icons.delete,
                                    color: BLACK_GREY, size: 20),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        (index == shoppingCartData.length - 1)
            ? Wrap()
            : Divider(
          height: 32,
          color: Colors.grey[400],
        )
      ],
    );
  }

  Widget _buildOptioncheckParts(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                ],
              ),
              _checboxgood(value: 'breast' , primaryText: '회원사 공유 여부'),
              // Divider(
              //   height: 32,
              //   color: Colors.grey[400],
              // ),
              // _checboxgood(value: 'wings', primaryText: 'Chicken Wings', secondaryText: '0'),
            ],
          ),
        )
      ],
    );
  }

  //체크박스
  Widget _checboxgood({value = 'breast' , primaryText: '회원사 공유 여부'}){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        setState(() { //tap 시에 value 다시 잡아주고
          if(_goodParts.contains(value)){
            _goodParts.remove(value);
            _shared = "N";
          } else {
            if(_goodParts.length<_maxgoodParts){
              _goodParts.add(value);
              _shared = "Y";
            }
          }
        });
      print(_shared);
        },
      child: Row(
        children: [
          Text(primaryText, style: TextStyle(
              fontSize: 15,
              color: SOFT_BLUE,
              fontWeight: (_goodParts.contains(value))?FontWeight.bold:FontWeight.normal
          )),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: (_goodParts.contains(value)) ? PRIMARY_COLOR : BLACK77
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(4.0)
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: (_goodParts.contains(value))
                  ? Icon(
                Icons.check,
                size: 12.0,
                color: PRIMARY_COLOR,
              ):Icon(
                Icons.check_box_outline_blank,
                size: 12.0,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 16),


          // Spacer(),
          // Text(secondaryText, style: TextStyle( //수량나타내주는거
          //   fontSize: 13,
          //   color: BLACK77,
          // ))
        ],
      ),
    );
  }


  //저장시 confirm
  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('수리노하우'),
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