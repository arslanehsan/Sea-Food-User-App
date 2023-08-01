import 'package:flutter/material.dart';
import 'package:seefood/FirebaseHelper/CommonFirebaseHelper.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';
import 'package:seefood/Utils/Colors.dart';
import 'package:seefood/Utils/Images.dart';
import 'package:seefood/Utils/Toast.dart';

import '../../Objects/ProductObject.dart';
import '../../Utils/Router.dart';
import '../../Utils/dimensions.dart';

class SingleProductView extends StatefulWidget {
  final ProductObject product;
  final CustomerObject customer;
  final List<ProductObject> products;
  const SingleProductView(
      {super.key,
      required this.product,
      required this.products,
      required this.customer});

  @override
  State<SingleProductView> createState() => _SingleProductViewState();
}

class _SingleProductViewState extends State<SingleProductView> {
  late final double _screenWidth = MediaQuery.of(context).size.width;
  late final double _screenHeight = MediaQuery.of(context).size.height;
  late final ProductObject product = widget.product;
  int quantity = 0;
  bool liked = false;
  bool likedLoading = true;
  bool addToBasketLoading = false;

  Future<void> getLiked() async {
    await FirebaseDatabaseHelper()
        .getProductLiked(product: product)
        .then((value) {
      setState(() {
        liked = value;
        likedLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getLiked();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColor.backGroundColor,
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Container(
      height: _screenHeight,
      width: _screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageView(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title!,
                              style: const TextStyle(
                                color: AppThemeColor.pureBlackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeExtraLarge,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: AppThemeColor.orangeColor,
                                      size: Dimensions.fontSizeDefault,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      product.selectedCategoryName!,
                                      style: const TextStyle(
                                        color: AppThemeColor.dullFontColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
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
                                            decoration:
                                                TextDecoration.lineThrough),
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
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => _handleLike(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppThemeColor.orangeColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          // alignment: Alignment.center,
                          padding: const EdgeInsets.all(6),
                          child: likedLoading
                              ? Image.asset(
                                  Images.loading,
                                  width: 20,
                                )
                              : Icon(
                                  liked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: AppThemeColor.pureWhiteColor,
                                  size: 20,
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: AppThemeColor.pureBlackColor,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    product.shortDescription!,
                    style: const TextStyle(
                      color: AppThemeColor.dullFontColor,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _bottomView(),
        ],
      ),
    );
  }

  Widget _bottomView() {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColor.pureWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (quantity != 0) {
                        quantity--;
                      }
                    });
                  },
                  child: const Icon(
                    Icons.remove_circle_outline,
                    size: 28,
                  ),
                ),
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(
                    '$quantity',
                    style: const TextStyle(
                      color: AppThemeColor.pureBlackColor,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.fontSizeExtraLarge,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (quantity != 99) {
                        quantity++;
                      }
                    });
                  },
                  child: const Icon(
                    Icons.add_circle_outline,
                    size: 28,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                if (quantity > 0) {
                  setState(() {
                    addToBasketLoading = true;
                  });
                  await FirebaseDatabaseHelper()
                      .addProductToCart(product: product, quantity: quantity)
                      .then((done) {
                    if (done) {
                      setState(() {
                        addToBasketLoading = true;
                      });
                      Navigator.pop(context);
                    } else {
                      ShowToast().showNormalToast(msg: 'Something Wrong!');
                    }
                  });
                } else {
                  ShowToast()
                      .showNormalToast(msg: 'Please Chose Quantity First!');
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                width: 140,
                decoration: BoxDecoration(
                  color: AppThemeColor.orangeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: !addToBasketLoading
                    ? const Text(
                        'Add to Basket',
                        style: TextStyle(
                          color: AppThemeColor.pureWhiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      )
                    : Center(
                        child: Image.asset(
                          Images.loading,
                          width: 20,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageView() {
    return Container(
      height: _screenWidth / 1.3,
      width: _screenWidth,
      decoration: const BoxDecoration(
        color: AppThemeColor.greenColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeColor.grayColor,
            spreadRadius: 0,
            blurRadius: 25,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: AppThemeColor.pureWhiteColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                // alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppThemeColor.orangeColor,
                  size: 20,
                ),
              ),
            ),
            Center(
              child: Image.network(
                product.imageLink!,
                width: _screenWidth / 1.7,
                fit: BoxFit.fitWidth,
              ),
            ),
            GestureDetector(
              onTap: () => RouterClass().cartScreenRoute(
                  context: context,
                  products: widget.products,
                  customer: widget.customer),
              child: Container(
                decoration: BoxDecoration(
                  color: AppThemeColor.pureWhiteColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                // alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.shopping_bag,
                  color: AppThemeColor.orangeColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLike() async {
    setState(() {
      likedLoading = true;
    });
    if (liked) {
      await FirebaseDatabaseHelper()
          .removeProductLike(product: product)
          .then((done) {
        setState(() {
          likedLoading = false;
          liked = !liked;
        });
      });
    } else {
      await FirebaseDatabaseHelper()
          .addProductLike(product: product)
          .then((done) {
        setState(() {
          likedLoading = false;
          liked = !liked;
        });
      });
    }
  }
}
