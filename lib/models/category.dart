class Category {
  String title;
  int lessonCount;
  int money;
  double rating;
  String imagePath;

  Category({
    this.title = '',
    this.imagePath = '',
    this.lessonCount = 0,
    this.money = 0,
    this.rating = 0.0,
  });

  static List<Category> categoryList = [
    Category(
      imagePath:
          "https://cdn.survivorsrest.com/img/h1z1/items/navy-suit-jacket.png",
      title: 'Clothing',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Category(
      imagePath:
          'https://cdn.iconscout.com/icon/premium/png-256-thumb/shoes-20-102425.png',
      title: 'Shoes',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
    ),
    Category(
      imagePath:
          'https://cdn.iconscout.com/icon/premium/png-256-thumb/ladies-pants-1759439-1497337.png',
      title: 'Pants',
      lessonCount: 24,
      money: 25,
      rating: 4.3,
    ),
    Category(
      imagePath:
          'https://cdn.iconscout.com/icon/premium/png-256-thumb/ladies-pants-1759439-1497337.png',
      title: 'Acessories',
      lessonCount: 22,
      money: 18,
      rating: 4.6,
    ),
  ];

  static List<Category> popularCourseList = [
    Category(
      imagePath:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      title: 'Clothing',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Category(
      imagePath:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      title: 'Web Design Course',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
    Category(
      imagePath:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      title: 'App Design Course',
      lessonCount: 12,
      money: 25,
      rating: 4.8,
    ),
    Category(
      imagePath:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      title: 'Web Design Course',
      lessonCount: 28,
      money: 208,
      rating: 4.9,
    ),
  ];
}
