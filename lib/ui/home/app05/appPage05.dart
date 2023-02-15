import 'package:actasm/config/constant.dart';
import 'package:actasm/config/global_style.dart';
import 'package:actasm/model/chat_model.dart';
import 'package:actasm/ui/reusable/reusable_widget.dart';
import 'package:actasm/ui/reusable/cache_image_network.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/banner_slider_model.dart';

class AppPage05 extends StatefulWidget {
  @override
  _AppPage05State createState() => _AppPage05State();
}

class _AppPage05State extends State<AppPage05> {
  // initialize reusable widget
  final _reusableWidget = ReusableWidget();

  TextEditingController _etChat = TextEditingController();

  String _lastDate = '13 Sep 2019';

  List<ChatModel> _chatList = [];
  List<ChatModel> _chatListReversed = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initForLang();
    });

    super.initState();
  }

  void _initForLang() {
    setState(() {

      // set chat dummy data
      _chatList.add(new ChatModel(1, null, 'date', '9 Sep 2019', null, null));
      _chatList.add(new ChatModel(2, 'buyer', 'text', 'Good morning', '13:59', true));
      _chatList.add(new ChatModel(3, 'buyer', 'image', GLOBAL_URL+'/product/80.jpg', null, null));
      _chatList.add(new ChatModel(4, 'buyer', 'text', 'I want to ask about the samsung tv product', '13:59', true));
      _chatList.add(new ChatModel(5, 'buyer', 'text', 'Is the Samsung LED TV 32 Inch is still on sale ?', '14:01', true));
      _chatList.add(new ChatModel(6, 'seller', 'text', 'Hello, thank you for contacting us', '14:18', true));
      _chatList.add(new ChatModel(7, 'seller', 'text', 'We are sorry, but the promotion for Samsung LED TV 32 Inch has ended. Don\'t forget to turn on notification setting for promotion so you will get the news about our product', '14:20', null));
      _chatList.add(new ChatModel(8, 'buyer', 'text', 'Ok, thank you for your information.', '14:22', true));
      _chatList.add(new ChatModel(9, null, 'date', '13 Sep 2019', null, null));
      _chatList.add(new ChatModel(10, 'buyer', 'image', GLOBAL_URL+'/product/21.jpg', null, null));
      _chatList.add(new ChatModel(11, 'buyer', 'text', 'Hi, is Adidas Polo Shirt size L is ready ? For the black color.', '08:58', true));
      _chatList.add(new ChatModel(12, 'buyer', 'text', 'I want to order for 2 pcs.', '09:00', true));
      _chatList.add(new ChatModel(13, 'buyer', 'text', 'And can I change it if the size doesn\'t fit my body?', '09:00', true));
      _chatList.add(new ChatModel(14, 'seller', 'text', 'Hello, good morning. The product is ready and you can change if the size is not fit your body', '09:14', null));

      // reverse the list
      _chatListReversed = _chatList.reversed.toList();
    });
  }

  @override
  void dispose() {
    _etChat.dispose();
    super.dispose();
  }

  void _addDate(String currentDate){
    _chatListReversed.insert(0, new ChatModel(15, null, 'date', currentDate, null, null));
  }

  void _addMessage(String message){
    DateTime now = DateTime.now();
    String _currentTime = DateFormat('kk:mm').format(now);
    _chatListReversed.insert(0, new ChatModel(16, 'buyer', 'text', message, _currentTime, false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: GlobalStyle.appBarIconThemeColor,
          ),
          elevation: GlobalStyle.appBarElevation,
          title: Text(
            '수리 Q&A',
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          bottom: _reusableWidget.bottomAppBar(),
        ),
        body:ListView(
                padding: EdgeInsets.all(16),
                  children: [
                    // Container(
                    //   height: 60,
                    //   child: TextFormField(
                    //     controller: _etChat,
                    //     minLines: 1,
                    //     maxLines: 4,
                    //     textAlignVertical: TextAlignVertical.bottom,
                    //     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    //     onChanged: (textValue) {
                    //       setState(() {});
                    //     },
                    //     decoration: InputDecoration(
                    //       fillColor: Colors.grey[200],
                    //       filled: true,
                    //       hintText: 'textfield',
                    //       focusedBorder: UnderlineInputBorder(
                    //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    //           borderSide: BorderSide(color: Colors.grey[200]!)),
                    //       enabledBorder: UnderlineInputBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    //         borderSide: BorderSide(color: Colors.grey[200]!),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container( //높이랑 너비가 없었음
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xffcccccc),
                                width: 1.0,
                              ),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height,
                         child: Column(
                          children: [
                           ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: _chatListReversed.length,
                            itemBuilder: (context, index) {
                              if(_chatListReversed[index].getTextImageDate=='date'){
                                return
                                  Column(
                                    children:[
                                  _buildDate(_chatListReversed[index].getMessage),
                                      _buildList(),]);
                              } else if(_chatListReversed[index].getTextImageDate=='image'){
                                return _buildImage(_chatListReversed[index].getMessage);
                              } else {
                                if(_chatListReversed[index].getType=='buyer'){
                                  return _buildChatBuyer(_chatListReversed[index].getMessage, _chatListReversed[index].getDate!, _chatListReversed[index].getRead!);
                                } else {
                                  return _buildChatSeller(_chatListReversed[index].getMessage, _chatListReversed[index].getDate!);
                                }
                              }
                            },
                          ),
                         ],
                          ),
                        ),
                  ),
                   ],
              ),
    );
  }

  Widget _buildDate(String date){
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
        bottom: BorderSide(
        color: Color(0xffcccccc),
        width: 1.5
        ),
        ),
    ),
      child: Row(
        children: [
          Center(
            child: Text(date, style: TextStyle(
                color: SOFT_GREY, fontSize: 11
            )),
          ),
        SizedBox(
          width: 130,
        ),
        Center(
          child: Text('아무개가 작성한 질문입니다.', style: TextStyle(
              color: SOFT_GREY, fontSize: 11
          )),
        ),
        ],
      ),
      );

  }




  //게시글 디자인
  Widget _buildList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffcccccc),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox( //왼쪽 크기 정하기
                    width: 0,
                    height: 40,
                  ),
                  Container(
                    child: Text('제목:', style: TextStyle(
                        fontSize:11, fontWeight: FontWeight.bold, color: SOFT_BLUE
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Text('작성자 , 구분 ', style: TextStyle(
                            fontSize: 11, color: CHARCOAL
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildChatBuyer(String message, String time, bool read){
    final double boxChatSize = MediaQuery.of(context).size.width/1.3;
    return Container(
      margin:EdgeInsets.only(top: 4),
      child: Wrap(
        alignment: WrapAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: boxChatSize),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Colors.grey[300]!
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(12),
                ),
                color: Colors.grey[300]
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(message, style: TextStyle(
                      color: CHARCOAL
                  )),
                ),
                Wrap(
                  children: [
                    SizedBox(width: 4),
                    Icon(Icons.done_all, color: SOFT_BLUE, size: 11),
                    SizedBox(width: 2),
                    Text(time, style: TextStyle(
                        color: SOFT_GREY, fontSize: 9
                    )),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSeller(String message, String date){
    final double boxChatSize = MediaQuery.of(context).size.width/1.3;
    return Container(
      margin:EdgeInsets.only(top: 4),
      child: Wrap(
        children: [
          Container(
              constraints: BoxConstraints(maxWidth: boxChatSize),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: Colors.grey[300]!
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(5),
                  )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(message, style: TextStyle(
                        color: CHARCOAL
                    )),
                  ),
                  Wrap(
                    children: [
                      SizedBox(width: 2),
                      Text(date, style: TextStyle(
                          color: SOFT_GREY, fontSize: 9
                      )),
                    ],
                  )
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl){
    final double boxChatSize = MediaQuery.of(context).size.width/1.3;
    final double boxImageSize = (MediaQuery.of(context).size.width / 6);
    return Container(
      margin:EdgeInsets.only(top: 4),
      child: Wrap(
        alignment: WrapAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: boxChatSize),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Colors.grey[300]!
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(12),
                )
            ),
            child: Container(
              width: boxImageSize,
              height: boxImageSize,
              child: ClipRRect(
                  borderRadius:
                  BorderRadius.all(Radius.circular(8)),
                  child: buildCacheNetworkImage(width: boxImageSize, height: boxImageSize, url: imageUrl)),
            ),
          ),
        ],
      ),
    );
  }
}
