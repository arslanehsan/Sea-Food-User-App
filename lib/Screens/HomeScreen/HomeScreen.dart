import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';
import 'package:seefood/Screens/HomeScreen/AccountScreen.dart';
import 'package:seefood/Screens/HomeScreen/LikedScreen.dart';
import 'package:seefood/Screens/Order/OrderHistoryScreen.dart';
import 'package:seefood/Utils/Router.dart';
import 'package:seefood/Utils/dimensions.dart';

import '../../FirebaseHelper/CommonFirebaseHelper.dart';
import '../../Objects/BannerObject.dart';
import '../../Objects/CategoryObject.dart';
import '../../Objects/ProductObject.dart';
import '../../Utils/Colors.dart';
import '../Auth/Firebase/FirebaseDatabaseService.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({
    super.key,
  });

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  late final double _screenHeight = MediaQuery.of(context).size.height;
  late final double _screenWidth = MediaQuery.of(context).size.width;

  CustomerObject? _customer;

  final NotchBottomBarController _bottomBarController =
      NotchBottomBarController();

  bool _bannersLoading = true;
  List<BannerObject> _banners = [];
  bool _categoriesLoading = true;
  List<CategoryObject> _categories = [];
  bool _productsLoading = true;
  List<ProductObject> _products = [];

  CategoryObject? _selectedCategory;

  int _selectedTab = 0;

  Future<void> _getProducts() async {
    await FirebaseDatabaseHelper().getProducts().then((productsData) {
      setState(() {
        _products = productsData;
        _productsLoading = false;
      });
    });
  }

  Future<void> _getCategories() async {
    await FirebaseDatabaseHelper().getCategories().then((categoriesData) {
      setState(() {
        _categories = categoriesData;
        _selectedCategory = categoriesData.first;
        _categoriesLoading = false;
      });
    });
  }

  Future<void> _getBanners() async {
    await FirebaseDatabaseHelper().getBanners().then((bannersData) {
      setState(() {
        _banners = bannersData;
        _bannersLoading = false;
      });
    });
  }

  Future<void> _getProfile() async {
    await AuthFirebaseDatabaseService()
        .getCustomerProfile()
        .then((customerData) {
      if (customerData != null) {
        setState(() {
          _customer = customerData;
        });
      }
    });
  }

  List<ProductObject> _getSortedProducts() {
    List<ProductObject> productListData = [];
    for (var singleProduct in _products) {
      if (singleProduct.selectedCategoryId == _selectedCategory!.id!) {
        productListData.add(singleProduct);
      }
    }
    return productListData;
  }

  @override
  void initState() {
    _getProfile();
    _getBanners();
    _getCategories();
    _getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _bodyView(),
      ),
    );
  }

  Widget _bodyView() {
    return Container(
      height: _screenHeight,
      width: _screenWidth,
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        color: AppThemeColor.backGroundColor,
      ),
      child: Stack(
        children: [
          if (_selectedTab == 0)
            Column(
              children: [
                _headerView(),
                const SizedBox(
                  height: Dimensions.spaceSizedDefault,
                ),
                if (_bannersLoading || _banners.isNotEmpty) _sliderView(),
                if (_bannersLoading || _banners.isNotEmpty)
                  const SizedBox(
                    height: Dimensions.spaceSizedDefault,
                  ),
                if (_categoriesLoading || _categories.isNotEmpty)
                  _categoriesView(),
                // if (_categoriesLoading || _categories.isNotEmpty)
                //   const SizedBox(
                //     height: Dimensions.spaceSizedDefault,
                //   ),
                if (_productsLoading || _products.isNotEmpty) _productsView(),
                if (_productsLoading || _products.isNotEmpty)
                  const SizedBox(
                    height: Dimensions.spaceSizedDefault,
                  ),
              ],
            ),
          if (_selectedTab == 1)
            LikedScreen(customer: _customer!, products: _products),
          if (_selectedTab == 2)
            OrderHistoryScreen(customer: _customer!, products: _products),
          if (_selectedTab == 3) AccountScreen(customer: _customer!),
          AnimatedNotchBottomBar(
            notchBottomBarController: _bottomBarController,
            showShadow: true,
            showBlurBottomBar: false,
            showLabel: false,
            blurOpacity: 10,
            notchColor: AppThemeColor.orangeColor,
            color: AppThemeColor.greenColor,
            itemLabelStyle: const TextStyle(
              color: AppThemeColor.pureWhiteColor,
            ),
            removeMargins: false,
            bottomBarItems: const [
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.home_outlined,
                  color: AppThemeColor.pureWhiteColor,
                ),
                activeItem: Icon(
                  Icons.home_filled,
                  color: AppThemeColor.pureWhiteColor,
                ),
                itemLabel: 'Home',
              ),
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.favorite_border,
                  color: AppThemeColor.pureWhiteColor,
                ),
                activeItem: Icon(
                  Icons.favorite,
                  color: AppThemeColor.pureWhiteColor,
                ),
                itemLabel: 'Page 2',
              ),
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.history_toggle_off,
                  color: AppThemeColor.pureWhiteColor,
                ),
                activeItem: Icon(
                  Icons.history,
                  color: AppThemeColor.pureWhiteColor,
                ),
                itemLabel: 'Page 2',
              ),
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.person_outline,
                  color: AppThemeColor.pureWhiteColor,
                ),
                activeItem: Icon(
                  Icons.person,
                  color: AppThemeColor.pureWhiteColor,
                ),
                itemLabel: 'Page 2',
              ),
            ],
            onTap: (selectedTabIndex) {
              setState(() {
                _selectedTab = selectedTabIndex;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _productsView() {
    print('products length is:${_products.length}');
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 15,
                runSpacing: 10,
                children: _getSortedProducts()
                    .map(
                      (singleProduct) =>
                          _singleProductView(product: singleProduct),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }

  Widget _singleProductView({required ProductObject product}) {
    double tabWidth = (_screenWidth / 2) - 28;
    return GestureDetector(
      onTap: () => RouterClass().singleProductScreenRoute(
          context: context,
          product: product,
          products: _products,
          customer: _customer!),
      child: Container(
        width: tabWidth,
        height: tabWidth * 1.25,
        decoration: BoxDecoration(
          color: _productsLoading
              ? Colors.black.withOpacity(0.05)
              : AppThemeColor.pureWhiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.imageLink!,
                width: tabWidth - 10,
                height: (tabWidth * 1.25) / 1.3,
                fit: BoxFit.fitWidth,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title!,
                      style: const TextStyle(
                        color: AppThemeColor.pureBlackColor,
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),
                    Row(
                      children: [
                        if (product.discount! > 0)
                          Text(
                            '\$${product.price!}',
                            style: const TextStyle(
                                color: AppThemeColor.dullFontColor,
                                fontWeight: FontWeight.w400,
                                fontSize: Dimensions.fontSizeSmall,
                                decoration: TextDecoration.lineThrough),
                          ),
                        if (product.discount! > 0)
                          const SizedBox(
                            width: 4,
                          ),
                        Text(
                          '\$${product.price! - product.discount!}',
                          style: const TextStyle(
                            color: AppThemeColor.pureBlackColor,
                            fontWeight: FontWeight.w400,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.add_box_outlined,
                  size: 28,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoriesView() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: _screenWidth,
      child: ListView.builder(
          itemCount: _categoriesLoading ? 6 : _categories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return _singleCategoryView(
              singleCategory: _categoriesLoading ? null : _categories[index],
            );
          }),
    );
  }

  Widget _singleCategoryView({required CategoryObject? singleCategory}) {
    bool currentCategory = _selectedCategory == singleCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = singleCategory;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 65,
            margin: const EdgeInsets.only(
              right: 7,
            ),
            decoration: _categoriesLoading
                ? BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                  )
                : BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      opacity: currentCategory ? 1 : 100,
                      image: NetworkImage(
                        singleCategory!.imageLink!,
                      ),
                    ),
                  ),
          ),
          Text(
            _categoriesLoading ? '' : singleCategory!.title!,
            style: TextStyle(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.w400,
              color: currentCategory
                  ? AppThemeColor.pureBlackColor
                  : AppThemeColor.dullFontColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sliderView() {
    return Container(
      height: 100,
      width: _screenWidth,
      decoration: _banners.isNotEmpty
          ? const BoxDecoration()
          : BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.04),
            ),
      child: _banners.isNotEmpty
          ? CarouselSlider.builder(
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.15,
                // onPageChanged: callbackFunction,
                scrollDirection: Axis.horizontal,
              ),
              itemCount: _banners.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.04),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          _banners[itemIndex].imageLink!,
                        ))),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _headerView() {
    return GestureDetector(
      onTap: () => RouterClass().profileScreenRoute(context: context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome ',
                  style: TextStyle(
                    fontSize: Dimensions.paddingSizeExtraLarge,
                    fontWeight: FontWeight.w700,
                    color: AppThemeColor.orangeColor,
                  ),
                ),
                if (_customer != null)
                  Text(
                    _customer!.name!,
                    style: const TextStyle(
                      fontSize: Dimensions.paddingSizeExtraLarge,
                      fontWeight: FontWeight.w700,
                      color: AppThemeColor.greenColor,
                    ),
                  ),
              ],
            ),
            InkWell(
              onTap: () => RouterClass().cartScreenRoute(
                  context: context, products: _products, customer: _customer!),
              child: const Icon(
                Icons.shopping_bag,
                color: AppThemeColor.greenColor,
                size: 28,
              ),
            )
            // Container(
            //   height: 40,
            //   width: 40,
            //   decoration: const BoxDecoration(
            //       image: DecorationImage(
            //           image: AssetImage(
            //     Images.inAppLogo,
            //   ))),
            // ),
          ],
        ),
      ),
    );
  }
}
