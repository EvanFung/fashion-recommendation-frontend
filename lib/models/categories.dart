import 'package:flutter/material.dart';

List categories = [
  {
    "name": "Accessories",
    "color1": Color.fromARGB(100, 0, 0, 0),
    "color2": Color.fromARGB(100, 0, 0, 0),
    "img": "assets/images/accessories.jpg"
  },
  {
    "name": "Personal Care",
    "color1": Color.fromARGB(100, 0, 0, 0),
    "color2": Color.fromARGB(100, 0, 0, 0),
    "img": "assets/images/personalCare.jpeg"
  },
  {
    "name": "Shoes",
    "color1": Color.fromARGB(100, 0, 0, 0),
    "color2": Color.fromARGB(100, 0, 0, 0),
    "img": "assets/images/shoes.jpeg"
  },
  {
    "name": "Clothes",
    "color1": Color.fromARGB(100, 0, 0, 0),
    "color2": Color.fromARGB(100, 0, 0, 0),
    "img": "assets/images/clothes.jpeg"
  },
];

class SubCategory {
  final String name;
  final String img;
  SubCategory({this.name, this.img});
}

Map<String, List<SubCategory>> subCategories = {
  'All': [
    SubCategory(name: 'Watches', img: 'assets/images/watch.jpeg'),
    SubCategory(name: 'Socks', img: 'assets/images/socks.jpeg'),
    SubCategory(name: 'Belts', img: 'assets/images/belts.jpeg'),
    SubCategory(name: 'Bags', img: 'assets/images/bags.jpeg'),
    SubCategory(
        name: 'Shoe Accessories', img: 'assets/images/shoe_accesories.jpeg'),
    SubCategory(name: 'Jewellery', img: 'assets/images/jewellery.jpeg'),
    SubCategory(name: 'Wallets', img: 'assets/images/wallents.jpeg'),
    SubCategory(name: 'Accessories', img: 'assets/images/accessories.jpeg'),
    SubCategory(name: 'Eyewear', img: 'assets/images/eyewear.jpeg'),
    SubCategory(name: 'Ties', img: 'assets/images/ties.jpeg'),
    SubCategory(name: 'Fragrance', img: 'assets/images/fragrance.jpeg'),
    SubCategory(name: 'Lips', img: 'assets/images/lips.jpeg'),
    SubCategory(name: 'Skin Care', img: 'assets/images/skincare.jpeg'),
    SubCategory(name: 'Makeup', img: 'assets/images/makeup.jpeg'),
    SubCategory(name: 'Shoes', img: 'assets/images/shoes.jpeg'),
    SubCategory(name: 'Flip Flops', img: 'assets/images/flipflops.jpeg'),
    SubCategory(name: 'Sandal', img: 'assets/images/sandal.jpeg'),
    SubCategory(name: 'Topwear', img: 'assets/images/clothes.jpeg'),
    SubCategory(name: 'Bottomwear', img: 'assets/images/bottomwear.jpeg'),
    SubCategory(name: 'Innerwear', img: 'assets/images/innerwear.jpeg'),
    SubCategory(name: 'Nightwear', img: 'assets/images/nightwear.jpeg'),
    SubCategory(name: 'Saree', img: 'assets/images/saree.jpeg'),
    SubCategory(name: 'Dress', img: 'assets/images/dress.jpeg'),
  ],
  'Accessories': [
    SubCategory(name: 'Watches', img: 'assets/images/watch.jpeg'),
    SubCategory(name: 'Socks', img: 'assets/images/socks.jpeg'),
    SubCategory(name: 'Belts', img: 'assets/images/belts.jpeg'),
    SubCategory(name: 'Bags', img: 'assets/images/bags.jpeg'),
    SubCategory(
        name: 'Shoe Accessories', img: 'assets/images/shoe_accesories.jpeg'),
    SubCategory(name: 'Jewellery', img: 'assets/images/jewellery.jpeg'),
    SubCategory(name: 'Wallets', img: 'assets/images/wallents.jpeg'),
    SubCategory(name: 'Accessories', img: 'assets/images/accessories.jpeg'),
    SubCategory(name: 'Eyewear', img: 'assets/images/eyewear.jpeg'),
    SubCategory(name: 'Ties', img: 'assets/images/ties.jpeg'),
  ],
  'Personal Care': [
    SubCategory(name: 'Fragrance', img: 'assets/images/fragrance.jpeg'),
    SubCategory(name: 'Lips', img: 'assets/images/lips.jpeg'),
    SubCategory(name: 'Skin Care', img: 'assets/images/skincare.jpeg'),
    SubCategory(name: 'Makeup', img: 'assets/images/makeup.jpeg'),
  ],
  'Shoes': [
    SubCategory(name: 'Shoes', img: 'assets/images/shoes.jpeg'),
    SubCategory(name: 'Flip Flops', img: 'assets/images/flipflops.jpeg'),
    SubCategory(name: 'Sandal', img: 'assets/images/sandal.jpeg'),
  ],
  'Clothes': [
    SubCategory(name: 'Topwear', img: 'assets/images/clothes.jpeg'),
    SubCategory(name: 'Bottomwear', img: 'assets/images/bottomwear.jpeg'),
    SubCategory(name: 'Innerwear', img: 'assets/images/innerwear.jpeg'),
    SubCategory(name: 'Nightwear', img: 'assets/images/nightwear.jpeg'),
    SubCategory(name: 'Saree', img: 'assets/images/saree.jpeg'),
    SubCategory(name: 'Dress', img: 'assets/images/dress.jpeg'),
  ]
};
