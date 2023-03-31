import 'dart:convert';
import 'package:actasm/config/constant.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map> Usercheck(String userid, String userpw) async{
// SharedPreferences 인스턴스 생성
  final prefs = await SharedPreferences.getInstance();
// playerId 가져오기
  final _playerId = prefs.getString('playerId');
  // print ('pushid있나요????????????????????????');
  print (_playerId);

  Map<String, dynamic> userinfo = {};
  var uritxt = CLOUD_URL + '/authm/loginmchk';
  var encoded = Uri.encodeFull(uritxt);

  Uri uri = Uri.parse(encoded);
  //'Content-Type': 'application/x-www-form-urlencoded',
  final response = await http.post(
    uri,
    headers: <String, String> {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept' : 'application/json'
    },
    body: <String, String> {
      'userid': userid,
      'userpw': userpw,
      'pushid': _playerId.toString(),
    },
  );
  if(response.statusCode == 200){
    userinfo = jsonDecode(response.body);
    // await SessionManager().set('userinfo', userinfo);
    // userinfo u = userinfo.fromJson(await SessionManager().get("saupnum"));
    // print(userinfo);
    await SessionManager().set("userid", userinfo['userid']);
    await SessionManager().set("username", userinfo['username']);
    await SessionManager().set("useyn", userinfo['useyn']);
    await SessionManager().set("saupnum", userinfo['saupnum']);
    await SessionManager().set("phone", userinfo['phone']);
    await SessionManager().set("actcd", userinfo['actcd']);
    ///int 불가능 String으로 변수 받아옴
    // await SessionManager().set("seq", userinfo['seq']);
    // await SessionManager().set("pushid", userinfo['pushid']);
    // await SessionManager().set("cltcd", userinfo['cltcd']);
    // await SessionManager().set("flag", userinfo['flag']);
    await SessionManager().set("dbnm", userinfo['dbnm']);
    await SessionManager().set("perid", userinfo['perid']);
    // await SessionManager().set("pernm", userinfo['pernm']);
    // dynamic user_saupnum = await SessionManager().get("saupnum");
    // print("제발~~~~~~~~~ ${userinfo['seq']}"); // userinfo['seq'] 값 출력

    //Update session
    //  await SessionManager().update();
    //Delete session and all data in it
    //  await SessionManager().destroy();
    //Remove a specific item
    //  await SessionManager().remove("id");
    //Verify wether or not a key exists
    //  await SessionManager().containsKey("id"); // true or false
  }else{
    // throw Exception('Failed to load data');
  }

  return userinfo;
}