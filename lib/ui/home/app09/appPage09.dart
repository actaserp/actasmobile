

import 'dart:convert';

import 'package:actasm/config/global_style.dart';
import 'package:actasm/config/constant.dart';
import 'package:actasm/model/app02/books.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../../model/app04/EmanualList_model.dart';
import '../../account/tab_account.dart';
import '../tab_home.dart';
import 'appPage09_view.dart';



class AppPage09 extends StatefulWidget {
  @override
  _AppPage09State createState() => _AppPage09State();
}

class _AppPage09State extends State<AppPage09> {
  TextEditingController _etSearch = TextEditingController();
  TextEditingController _emSearch = TextEditingController();

  List<EmanualList_model> eDatas = EData;
  String dropdownValue = "%" ?? "";

  bool chk = true;




  @override
  void initState(){
    super.initState();
    elist_getdata();

  }

  @override
  void dispose(){
    _etSearch.dispose();
    EData.clear();
    super.dispose();
  }

  Future elist_getdata() async {
    String _dbnm = await  SessionManager().get("dbnm");

    var uritxt = CLOUD_URL + '/appmobile/elist';
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
        'subject': _etSearch.text,
        'memo': _emSearch.text,
        'groupcd': dropdownValue

      },
    );
    if(response.statusCode == 200){
      List<dynamic> alllist = [];
      alllist =  jsonDecode(utf8.decode(response.bodyBytes))  ;
      EData.clear();
      for (int i = 0; i < alllist.length; i++) {
        EmanualList_model emObject= EmanualList_model(
            custcd:alllist[i]['custcd'],
            spjangcd:alllist[i]['spjangcd'],
            eseq:alllist[i]['eseq'],
            einputdate:alllist[i]['einputdate'],
            egroupcd:alllist[i]['egourupcd'],
            esubject:alllist[i]['esubject'],
            efilename:alllist[i]['efilename'],
            epernm:alllist[i]['epernm'],
            ememo:alllist[i]['ememo'],
            eflag:alllist[i]['eflag'],
            attcnt:alllist[i]['attcnt'],
            cnam:alllist[i]['cnam']
        );
        setState(() {
          EData.add(emObject);
        });

      }
      return EData;
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }


  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: GlobalStyle.appBarIconThemeColor,
          ),
          elevation: GlobalStyle.appBarElevation,
          title: Text(
            '기타자료실',
            style: GlobalStyle.appBarTitle,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(onPressed: (){

                setState(() {
                  chk = true;
                  elist_getdata();
                });
                /*searchBook(_etSearch.text);*/
                /*searchBook2(_etSearch2.text);*/
              }, child: Text('검색하기')),
            )
            /*IconButton(onPressed: (){
              print('검색');
            }, icon: Icon(Icons.search))*/
          ],
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,

        ),
        body:

        WillPopScope(
          onWillPop: (){
            Navigator.pop(context);
            return Future.value(true);
          },
          child: Column(
            children: [
              Container(

                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[100]!,
                        width: 1.0,
                      )
                  ),
                ),
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                height: kToolbarHeight,
                child: TextField(
                  controller: _etSearch,
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),

                  /*onChanged: searchBook,*/
                  decoration: InputDecoration(
                    fillColor: Colors.grey[100],
                    filled: true,
                    hintText: '제목',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    suffixIcon: (_etSearch.text == '')
                        ? null
                        : GestureDetector(
                        onTap: () {
                          setState(() {
                            _etSearch = TextEditingController(text: '');
                          });
                        },
                        child: Icon(Icons.close, color: Colors.grey[500])),
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.grey[200]!)),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                ),

              ),
              Container(

                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[100]!,
                        width: 1.0,
                      )
                  ),
                ),
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                height: kToolbarHeight,
                child: TextField(
                  controller: _emSearch,
                  textAlignVertical: TextAlignVertical.bottom,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),

                  /*onChanged: searchBook,*/
                  decoration: InputDecoration(
                    fillColor: Colors.grey[100],
                    filled: true,
                    hintText: '내용',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    suffixIcon: (_emSearch.text == '')
                        ? null
                        : GestureDetector(
                        onTap: () {
                          setState(() {
                            _emSearch = TextEditingController(text: '');
                          });
                        },
                        child: Icon(Icons.close, color: Colors.grey[500])),
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.grey[200]!)),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                ),

              ),
              Container(
                  child: Column(
                    children: [
                      DropdownButtonFormField <String?>(
                        decoration: InputDecoration(
                          labelText: '분류',
                          labelStyle: TextStyle(fontSize: 20, color: Color(0xffcfcfcf)),
                        ),
                        onChanged: (String? newValue) {
                          print(newValue);
                          setState(() {
                            dropdownValue = newValue ?? "";
                          });
                        },
                        items:
                        [null, '01', '02'].map<DropdownMenuItem<String?>>((String? i) {
                          return DropdownMenuItem<String?>(
                            value: i,
                            child: Text({'01': '현대엘리베이터', '02': '기타제작사'}[i] ?? '전체'),
                          );
                        }).toList(),
                      )
                    ],
                  )
              ),

              chk ? Expanded(

                child: ListView.builder(itemCount: eDatas.length,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index){
                    return _buildListCard(eDatas[index]);
                  },
                ),
              ) : Text("자료를 검색하세요."),

            ],
          ),

        ),
      bottomNavigationBar:  BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) { // 1번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AppPage09()));          }
          if (index == 1) { // 2번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TabHomePage()));          }
          if (index == 2) { // 3번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TabAccountPage()));            }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: '새로고침',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

    );

  }


  void searchBook(String query){
    final suggestions = EData.where((data) {
      final bookTitle = data.esubject.toString();
      final input = query.toString();
      return bookTitle.contains(input);
    }).toList();

    setState(() => eDatas = suggestions);
  }

  /*void searchBook2(String query){
    final suggestions = EData.where((data) {
      final greginmtitle = data.greginm.toString();
      final input = query.toString();
      return greginmtitle.contains(input);
    }).toList();

    setState(() => eDatas = suggestions);
  }*/





  Widget _buildListCard(EmanualList_model EData){
    return Card(
      margin: EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 2,
      color: Colors.white,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage09view(EData: EData)));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('['+EData.cnam+'] '+EData.esubject, style: GlobalStyle.couponName),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GlobalStyle.iconTime,
                      SizedBox(
                        width: 4,
                      ),
                      Text(EData.einputdate+' ', style: GlobalStyle.couponExpired),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      // Fluttertoast.showToast(msg: 'Coupon applied', toastLength: Toast.LENGTH_LONG);
                    },
                    child: Text(EData.epernm, style: TextStyle(
                        fontSize: 14, color: SOFT_BLUE, fontWeight: FontWeight.bold
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('기타자료실'),
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

