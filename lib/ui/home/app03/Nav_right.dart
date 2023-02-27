import 'package:flutter/material.dart';

import '../../../model/app03/nav_model.dart';
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
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index){
                            return SizedBox(
                            height: 50,
                            child: ListTile(
                              leading: Icon(items[index].icon),
                           title: Text(items[index].title),
                               onTap: (){
                               Navigator.push(context, MaterialPageRoute(builder: items[index].page));

                       },
                      ),
                            );
                      }),
                    ),

              ],
              ),
              );
  }



}