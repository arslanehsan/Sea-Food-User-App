import 'package:flutter/material.dart';
import 'package:seefood/FirebaseHelper/CommonFirebaseHelper.dart';
import 'package:seefood/Objects/LikedObject.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';
import 'package:seefood/Utils/Router.dart';
import 'package:seefood/Utils/dimensions.dart';

import '../../Objects/ProductObject.dart';
import '../../Utils/Colors.dart';

class LikedScreen extends StatefulWidget {
  final CustomerObject customer;
  final List<ProductObject> products;
  const LikedScreen(
      {super.key, required this.customer, required this.products});

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  late final double _screenHeight = MediaQuery.of(context).size.height;
  late final double _screenWidth = MediaQuery.of(context).size.width;
  late final CustomerObject _customer = widget.customer;

  late final List<ProductObject> _products = widget.products;
  List<LikedObject> _likedProducts = [];
  bool _loadingProducts = true;

  List<ProductObject> _getSortedProducts() {
    List<ProductObject> productListData = [];
    for (var singleProduct in _products) {
      for (var element in _likedProducts) {
        if (element.id == singleProduct.id) {
          productListData.add(singleProduct);
        }
      }
    }
    return productListData;
  }

  Future<void> getLikedItems() async {
    await FirebaseDatabaseHelper().getLikedProducts().then((productsData) {
      setState(() {
        _likedProducts = productsData;
        _loadingProducts = false;
      });
      // productsData.forEach((element) {
      //   setState(() {
      //
      //   });
      //   print('${element.id} - ${element.liked}');
      // });
    });
  }

  @override
  void initState() {
    super.initState();
    getLikedItems();
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
      child: Column(
        children: [
          _headerView(),
          const SizedBox(
            height: Dimensions.spaceSizedDefault,
          ),
          !_loadingProducts
              ? _productsView()
              : const Expanded(
                  child: Center(
                    child: Text('Please Wait...'),
                  ),
                ),
          if (_products.isNotEmpty)
            const SizedBox(
              height: Dimensions.spaceSizedDefault,
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
          customer: _customer),
      child: Container(
        width: tabWidth,
        height: tabWidth * 1.25,
        decoration: BoxDecoration(
          color: AppThemeColor.pureWhiteColor,
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

  Widget _headerView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_customer.name!}\'s ',
                style: const TextStyle(
                  fontSize: Dimensions.paddingSizeExtraLarge,
                  fontWeight: FontWeight.w700,
                  color: AppThemeColor.orangeColor,
                ),
              ),
              const Text(
                'Favorites',
                style: TextStyle(
                  fontSize: Dimensions.paddingSizeExtraLarge,
                  fontWeight: FontWeight.w700,
                  color: AppThemeColor.greenColor,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () => RouterClass().cartScreenRoute(
                context: context, products: _products, customer: _customer),
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
    );
  }
}
