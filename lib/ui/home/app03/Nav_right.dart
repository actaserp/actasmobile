import 'package:flutter/material.dart';

import '../appPage02.dart';
import '../tab_home.dart';




class Nav_right extends StatelessWidget{
  final Widget text;
  final Color color;

  Nav_right(
      {Key? key,
  required this.text, required this.color,

      }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
              child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                    DrawerHeader(child:
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Actas',
                          style: TextStyle(
                          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
                          ),
                          ),
                        ),
                    decoration: BoxDecoration(
                    color: Colors.blue[800]
                    )),
                    ListTile(
                        title: GestureDetector(
                          onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TabHomePage()));
                          },
                            child:  Row(
                            children:[
                                Icon(Icons.home),
                                  SizedBox(
                                  width: 10),
                                  Text('Home'),
                                  ]))),
                    ListTile(
                        title: GestureDetector(
                        onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage02()));
                        },
                            child:  Row(
                            children:[
                            Icon(Icons.favorite),
                            SizedBox(
                            width: 10),
                            Text('고장 처리'),
                            ]))),
                    ListTile(
                        title: GestureDetector(
                        onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TabHomePage()));},
                            child:  Row(
                            children:[
                            Icon(Icons.safety_check),
                            SizedBox(
                            width: 10),
                            Text('현장 정보'),
                            ]))),
                    ListTile(
                        title: GestureDetector(
                        onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TabHomePage()));},
                            child:  Row(
                            children:[
                            Icon(Icons.person_outlined),
                            SizedBox(
                            width: 10),
                            Text('Account'),
                            ]))),
                ListTile(
                    title: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TabHomePage()));},
                        child:  Row(
                            children:[
                              SizedBox(height: MediaQuery.of(context).size.height/1.4,
                              width: 190),
                              Icon(Icons.door_back_door_outlined),
                              SizedBox(
                                  width: 10),
                              Text('Logout'),
                            ]))),
              ],
              ),
              );
  }



}