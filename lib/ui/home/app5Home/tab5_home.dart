import 'package:actasm/config/constant.dart';

import 'package:actasm/model/feature/category_model.dart';
import 'package:actasm/ui/account/tab_account.dart';
import 'package:actasm/ui/home/tab_home.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../model/banner_slider_model.dart';
import '../../reusable/cache_image_network.dart';
import '../../reusable/global_widget.dart';
import 'appPager07.dart';
import 'appPager08.dart';
import 'appPager09.dart';



class Tab5HomePage extends StatefulWidget {
  @override
  _Home1PageState createState() => _Home1PageState();
}

class _Home1PageState extends State<Tab5HomePage> {

  late PageController _pageController;
  int _currentIndex = 0;

  final List<Widget> _contentPages = <Widget>[
    TabHomePage(),

    TabAccountPage(),
  ];

  final _globalWidget = GlobalWidget();
  Color _color1 = Color(0xFF005288);
  Color _color2 = Color(0xFF37474f);
  var _usernm = "";
  int _currentImageSlider = 0;

  List<BannerSliderModel> _bannerData = [];
  List<CategoryModel> _categoryData = [];

  @override
  void initState(){
    _bannerData.add(BannerSliderModel(id: 1, image: HYUNDAI_URL + '/product_gallery/THE EL_main_Web(0).jpg'));
    _bannerData.add(BannerSliderModel(id: 2, image: HYUNDAI_URL + '/product_gallery/THE EL_4(1).jpg'));
    _bannerData.add(BannerSliderModel(id: 3, image: HYUNDAI_URL + '/product_gallery/THE EL_3(1).jpg'));
    _bannerData.add(BannerSliderModel(id: 4, image: HYUNDAI_URL + '/product_gallery/THE EL_2(1).jpg'));
    _bannerData.add(BannerSliderModel(id: 5, image: HYUNDAI_URL + '/product_characteristic/특징_02(0).jpg'));

    _categoryData.add(CategoryModel(id: 1, name:'현장별고장내용별현황', image: GLOBAL_URL+'/menu/credit_application_status.png', color: 0xffffff));
    _categoryData.add(CategoryModel(id: 2, name: '현장별고장부위별현황', image:GLOBAL_URL+'/menu/credit_payment.png', color: 0xffffff));
    _categoryData.add(CategoryModel(id: 2, name: '현장별고장원인별현황', image:GLOBAL_URL+'/menu/store.png', color: 0xD3D3D3));


    super.initState();
    setData();

  }

  Future<void> setData() async {
    _usernm = await SessionManager().get("username");

  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Image.asset(LOCAL_IMAGES_URL+'/logo.png', height: 24, color: Colors.white),
          backgroundColor: _color1,
          leading: IconButton(onPressed: (){
            Fluttertoast.showToast(msg: 'Click about us', toastLength: Toast.LENGTH_SHORT);

          }, icon: Icon(Icons.help_outline),),
          actions: <Widget>[
            IconButton(icon: _globalWidget.customNotifIcon(count: 8, notifColor: Colors.white),
                onPressed: (){
                  Fluttertoast.showToast(msg: 'Click notification', toastLength: Toast.LENGTH_SHORT);
                }),
            IconButton(icon: Icon(Icons.settings),
                onPressed: (){
                  Fluttertoast.showToast(msg: 'Click setting', toastLength: Toast.LENGTH_SHORT);
                }),
          ]),
      body: ListView(
        children: [
          _buildTop(),
          _bulidHomeBanner(),
          _createMenu(),



        ],
      ),



      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (value) {
          _currentIndex = value;
          _pageController.jumpToPage(value);
          // this unfocus is to prevent show keyboard in the wishlist page when focus on search text field
          FocusScope.of(context).unfocus();
        },
        selectedFontSize: 8,
        unselectedFontSize: 8,
        iconSize: 28,
        selectedLabelStyle: TextStyle(color: _currentIndex == 1 ? ASSENT_COLOR : PRIMARY_COLOR, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(color: CHARCOAL, fontWeight: FontWeight.bold),
        selectedItemColor: _currentIndex == 1 ? ASSENT_COLOR : PRIMARY_COLOR,
        unselectedItemColor: CHARCOAL,
        items: [
          BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? PRIMARY_COLOR : CHARCOAL
              )
          ),
          BottomNavigationBarItem(
              label: '고장처리',
              icon: Icon(
                  Icons.favorite,
                  color: _currentIndex == 1 ? ASSENT_COLOR : CHARCOAL
              )
          ),
          BottomNavigationBarItem(
              label: '현장정보',
              icon: Icon(
                  Icons.shopping_cart,
                  color: _currentIndex == 2 ? PRIMARY_COLOR : CHARCOAL
              )
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(
                Icons.person_outline,
                color: _currentIndex == 3 ? PRIMARY_COLOR : CHARCOAL

            ),


          ),
        ],
      ),
    );

  }

  Widget _buildTop(){
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              Fluttertoast.showToast(msg: 'Click profile picture', toastLength: Toast.LENGTH_SHORT);
            },
            child: Hero(tag: 'profilePicture',
              child: ClipOval(
                child: buildCacheNetworkImage(url: GLOBAL_URL+'/user/avatar.png', width: 50),
              ),
            ),
          ),
          Expanded(child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      Fluttertoast.showToast(msg: 'Click name', toastLength: Toast.LENGTH_SHORT);
                    },
                    child: Text(
                      _usernm + '님 반갑습니다.',
                      style: TextStyle(
                          color: _color2,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                ],
              )

          ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          GestureDetector(
            onTap: (){
              Fluttertoast.showToast(msg: "Click log out",toastLength: Toast.LENGTH_SHORT );
            },
            child: Text(
                'Log Out',
                style: TextStyle(color: _color2, fontWeight: FontWeight.bold)),
          )

        ],
      ),
    );
  }

  Widget _bulidHomeBanner(){
    return Stack(
      children: [
        CarouselSlider(items: _bannerData.map((item) => Container(
          child: GestureDetector(
              onTap: (){
                Fluttertoast.showToast(msg: 'Click banner '+item.id.toString(), toastLength: Toast.LENGTH_SHORT);
              },
              child: buildCacheNetworkImage(width: 0, height: 0, url: item.image)
          ),
        )).toList(),
          options: CarouselOptions(
              aspectRatio: 2,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 6),
              autoPlayAnimationDuration: Duration(milliseconds: 300),
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageSlider = index;
                });
              }
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  _bannerData.map((item) {
              int index = _bannerData.indexOf(item);
              return AnimatedContainer(
                duration: Duration(milliseconds: 150),
                width: _currentImageSlider == index?10:5,
                height: _currentImageSlider == index?10:5,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              );
            }).toList(),

          ),
        ),
      ],
    );
  }

  Widget _createMenu(){


    return GridView.count(childAspectRatio: 1.1,
      shrinkWrap: true,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      crossAxisCount: 3,
      children: List.generate(_categoryData.length, (index) {
        return GestureDetector(
          onTap: (){
            String ls_name = _categoryData[index].name.replaceAll('\n', ' ');
            switch (ls_name){
              case '현장별고장내용별현황' :
                Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager07()));
                break;
              case '현장별고장부위별현황' :
                Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager08()));

                break;
              case '현장별고장원인별현황' :
                Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager09()));
                break;
              default:
                break;
            }
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[100]!, width: 0.5),
                color: Colors.white),
            padding: EdgeInsets.all(8),
            child: Center(
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCacheNetworkImage(width: 30, height: 30, url: _categoryData[index].image, plColor: Colors.transparent),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    child: Text(
                      _categoryData[index].name,
                      style: TextStyle(
                          color: _color1,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ],

              ),
            ),
          ),

        );

      }),
    );
  }



// initialize global widget
}

