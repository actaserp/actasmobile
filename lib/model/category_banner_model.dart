import 'package:actasm/config/constant.dart';

class CategoryBannerModel {
  late int id;
  late String image;

  CategoryBannerModel({required this.id, required this.image});
}

List<CategoryBannerModel> categoryBannerData =[
  CategoryBannerModel(
      id: 1,
      image: GLOBAL_URL+'/apps/ecommerce/category_banner/1.jpg'
  ),
  CategoryBannerModel(
      id: 2,
      image: GLOBAL_URL+'/apps/ecommerce/category_banner/2.jpg'
  ),
  CategoryBannerModel(
      id: 3,
      image: GLOBAL_URL+'/apps/ecommerce/category_banner/3.jpg'
  ),
];