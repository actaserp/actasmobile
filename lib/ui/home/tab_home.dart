import 'package:carousel_slider/carousel_slider.dart';
import 'package:actasm/config/constant.dart';
import 'package:actasm/model/feature/banner_slider_model.dart';
import 'package:actasm/model/feature/category_model.dart';
import 'package:actasm/ui/reusable/cache_image_network.dart';
import 'package:actasm/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app04/appPage04.dart';
import 'app05/appPage05.dart';
import 'app08/appPage08.dart';
import 'app09/appPage09.dart';
import 'app10/appPage10.dart';

import 'app5Home/appPager10.dart';
import 'app5Home/appPager11.dart';
import 'app5Home/appPager12.dart';
import 'app5Home/appPager13.dart';
import 'app5Home/appPager14.dart';
import 'app5Home/appPager15.dart';
import 'app5Home/tab5_home.dart';
import 'appPage02.dart';
import 'app03/appPage03.dart';

class TabHomePage extends StatefulWidget {
  @override
  _Home1PageState createState() => _Home1PageState();
}

class _Home1PageState extends State<TabHomePage> {
  // initialize global widget
  final _globalWidget = GlobalWidget();
  Color _color1 = Color(0xFF005288);
  Color _color2 = Color(0xFF37474f);
  var _usernm = "";
  int _currentImageSlider = 0;

  List<BannerSliderModel> _bannerData = [];
  List<CategoryModel> _categoryData = [];

  @override
  void initState()  {
    //GLOBAL_URL+'/home_banner/1.jpg'));  LOCAL_IMAGES_URL+'/elvimg/1.jpg'
    _bannerData.add(BannerSliderModel(id: 1, image: HYUNDAI_URL + '/product_gallery/THE EL_main_Web(0).jpg'));
    _bannerData.add(BannerSliderModel(id: 2, image: HYUNDAI_URL + '/product_gallery/THE EL_4(1).jpg'));
    _bannerData.add(BannerSliderModel(id: 3, image: HYUNDAI_URL + '/product_gallery/THE EL_3(1).jpg'));
    _bannerData.add(BannerSliderModel(id: 4, image: HYUNDAI_URL + '/product_gallery/THE EL_2(1).jpg'));
    _bannerData.add(BannerSliderModel(id: 5, image: HYUNDAI_URL + '/product_characteristic/특징_02(0).jpg'));

    _categoryData.add(CategoryModel(id: 1, name: '고 장 접 수', image: GLOBAL_URL+'/menu/store.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 2, name: '고 장 처 리', image: GLOBAL_URL+'/menu/products.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 3, name: '점 검 계 획', image: GLOBAL_URL+'/menu/buy_online.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 4, name: '점 검 조 치', image: GLOBAL_URL+'/menu/apply_credit.png', color:0xD3D3D3));

    _categoryData.add(CategoryModel(id: 5, name: '도 면 자 료', image: GLOBAL_URL+'/menu/credit_application_status.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 6, name: '부 품 자 료', image: GLOBAL_URL+'/menu/credit_payment.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 7, name: '기 타 자 료', image: GLOBAL_URL+'/menu/commission.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 8, name: '현장정보\n승강기번호\n비상통화/조회', image: GLOBAL_URL+'/menu/contact_us.png', color:0xffffff));

    _categoryData.add(CategoryModel(id: 9, name: '수 리\n노 하 우', image: GLOBAL_URL+'/menu/store.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 10, name: '부 품\n가 이 드', image: GLOBAL_URL+'/menu/products.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 11, name: '수 리\nQ  &  A', image: GLOBAL_URL+'/menu/buy_online.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 12, name: '직 원 정 보', image: GLOBAL_URL+'/menu/apply_credit.png', color:0xD3D3D3));

    _categoryData.add(CategoryModel(id: 13, name: '고 장 이 력', image: GLOBAL_URL+'/menu/credit_application_status.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 14, name: '고 장 통 계', image: GLOBAL_URL+'/menu/credit_payment.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 15, name: '작 업 일 보', image: GLOBAL_URL+'/menu/commission.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 16, name: '공 지 사 항', image: GLOBAL_URL+'/menu/point.png', color:0xffffff));



    super.initState();
    setData();
  }


  Future<void> setData() async {
      _usernm = await  SessionManager().get("username");
  }

  @override
  void dispose() {
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
            leading: IconButton(
                icon: Icon(Icons.help_outline),
                onPressed: () {
                  Fluttertoast.showToast(msg: 'Click about us', toastLength: Toast.LENGTH_SHORT);
                }),
            actions: <Widget>[
              IconButton(
                  icon: _globalWidget.customNotifIcon(count: 8, notifColor: Colors.white),
                  onPressed: () {
                    Fluttertoast.showToast(msg: 'Click notification', toastLength: Toast.LENGTH_SHORT);
                  }),
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Fluttertoast.showToast(msg: 'Click setting', toastLength: Toast.LENGTH_SHORT);
                  })
            ]),
        body: ListView(
          children: [
            _buildTop(),
            _buildHomeBanner(),
            _createMenu()
          ],
        )
    );
  }

  Widget _buildTop(){
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Fluttertoast.showToast(msg: 'Click profile picture', toastLength: Toast.LENGTH_SHORT);
            },
            child: Hero(
              tag: 'profilePicture',
              child: ClipOval(
                child: buildCacheNetworkImage(url: GLOBAL_URL+'/user/avatar.png', width: 50),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
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
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          GestureDetector(
            onTap: () {
              Fluttertoast.showToast(msg: 'Click log out', toastLength: Toast.LENGTH_SHORT);
            },
            child: Text(
                'Log Out',
                style: TextStyle(color: _color2, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildHomeBanner(){
    return Stack(
      children: [
        CarouselSlider(
          items: _bannerData.map((item) => Container(
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
            children: _bannerData.map((item) {
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
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      ///cell ratio
      childAspectRatio: 0.3 / 0.5,
      shrinkWrap: true,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      crossAxisCount: 4,
      children: List.generate(_categoryData.length, (index) {
        return GestureDetector(
            onTap: () {
              // Fluttertoast.showToast(msg: 'Click '+_categoryData[index].name.replaceAll('\n', ' '), toastLength: Toast.LENGTH_SHORT);
              String ls_name = _categoryData[index].name.replaceAll('\n', ' ');
              switch (ls_name){
                case '고 장 접 수' :
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => CouponPage()));
                  break;
                case '고 장 처 리' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage02()));
                  break;
                case '점 검 계 획' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager15()));
                  break;
                case '점 검 조 치' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager13()));
                  break;
                case '도 면 자 료' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage08()));
                  break;
                case '부 품 자 료' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage10()));
                  break;
                case '기 타 자 료' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage09()));
                  break;
                case '현장정보 승강기번호 비상통화/조회' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager11()));
                  break;
                case '수 리 노 하 우' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage03()));
                  break;
                case '부 품 가 이 드' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage04()));

                  break;
                case '수 리 Q  &  A' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage05()));

                  break;
                case '직 원 정 보' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager10()));
                  break;
                case '고 장 이 력' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager12()));
                  break;
                case '고 장 통 계' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Tab5HomePage()));
                  break;
                case '작 업 일 보' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager11()));
                  break;
                case '공 지 사 항' :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager14()));
                  break;
                default:
                  break;
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[100]!, width: 0.5),
                  color: Colors.white),  //Colors.white
                  padding: EdgeInsets.all(8),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCacheNetworkImage(width: 30, height: 30, url: _categoryData[index].image, plColor:  Colors.transparent),
                        Container(
                          margin: EdgeInsets.only(top: 12),
                          child: Text(
                            _categoryData[index].name,
                            style: TextStyle(
                              color: _color1,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ])),
            ));
      }),
    );
  }
}
