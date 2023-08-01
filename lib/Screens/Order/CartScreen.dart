import 'package:flutter/material.dart';
import 'package:seefood/FirebaseHelper/CommonFirebaseHelper.dart';
import 'package:seefood/Objects/CartItemObject.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';
import 'package:seefood/Utils/Images.dart';
import 'package:seefood/Utils/Router.dart';
import 'package:seefood/Utils/dimensions.dart';

import '../../Objects/CheckOutObject.dart';
import '../../Objects/ProductObject.dart';
import '../../Utils/Colors.dart';

class CartScreen extends StatefulWidget {
  final List<ProductObject> products;
  final CustomerObject customer;
  const CartScreen({
    super.key,
    required this.products,
    required this.customer,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final double _screenHeight = MediaQuery.of(context).size.height;
  late final double _screenWidth = MediaQuery.of(context).size.width;

  bool loadingRemove = false;

  late final List<ProductObject> _products = widget.products;
  List<CartItemObject> _cartItems = [];
  int totalItems = 0;
  double totalPrice = 0;
  bool _loadingProducts = true;

  List<ProductObject> _getSortedProducts() {
    totalPrice = 0;
    List<ProductObject> productListData = [];
    for (var singleProduct in _products) {
      for (var element in _cartItems) {
        if (element.id == singleProduct.id) {
          productListData.add(singleProduct);
          setState(() {
            totalPrice = totalPrice +
                ((singleProduct.price! - singleProduct.discount!) *
                    getQuantityOfProduct(itemId: singleProduct.id!));
          });
        }
      }
    }
    return productListData;
  }

  Future<void> getCartItems() async {
    totalItems = 0;
    await FirebaseDatabaseHelper().getCartItems().then((productsData) {
      setState(() {
        _cartItems = productsData;
        _loadingProducts = false;
      });
      for (var element in productsData) {
        setState(() {
          totalItems = totalItems + element.quantity;
        });
      }
      // productsData.forEach((element) {
      //   setState(() {
      //
      //   });
      //   print('${element.id} - ${element.liked}');
      // });
    });
  }

  int getQuantityOfProduct({required String itemId}) {
    int quantity = 0;
    for (var element in _cartItems) {
      if (itemId == element.id) {
        quantity = element.quantity;
      }
    }
    return quantity;
  }

  @override
  void initState() {
    super.initState();
    getCartItems();
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
          _totalItemsView(),
          Expanded(
            child: Column(
              children: [
                (!_loadingProducts)
                    ? _cartItems.isNotEmpty
                        ? _productsView()
                        : const Expanded(
                            child: Center(
                              child: Text('Cart Empty!'),
                            ),
                          )
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
          ),
          _bottomView(),
        ],
      ),
    );
  }

  Widget _bottomView() {
    return Container(
      width: _screenWidth,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppThemeColor.pureBlackColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sub Total:',
                style: TextStyle(
                  color: AppThemeColor.pureBlackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
              Text(
                '\$$totalPrice',
                style: const TextStyle(
                  color: AppThemeColor.pureBlackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () => totalItems > 0 ? _makeCheckOut() : null,
            child: Container(
              width: _screenWidth,
              decoration: BoxDecoration(
                color: totalItems > 0
                    ? AppThemeColor.greenColor
                    : AppThemeColor.greenColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                'Check Out',
                style: TextStyle(
                  color: AppThemeColor.pureWhiteColor,
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _totalItemsView() {
    return Container(
      width: _screenWidth,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppThemeColor.pureBlackColor,
            width: 1,
          ),
        ),
      ),
      child: Text(
        '$totalItems items',
        style: const TextStyle(
          color: AppThemeColor.pureBlackColor,
          fontWeight: FontWeight.w700,
          fontSize: Dimensions.fontSizeLarge,
        ),
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
    double tabWidth = _screenWidth;
    return GestureDetector(
      // onTap: () => RouterClass()
      //     .singleProductScreenRoute(context: context, product: product),
      child: Container(
        width: tabWidth,
        height: 100,
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
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.imageLink!,
                width: 80,
                height: 80,
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(
                              product.shortDescription!,
                              style: const TextStyle(
                                color: AppThemeColor.pureBlackColor,
                                fontWeight: FontWeight.w400,
                                fontSize: Dimensions.fontSizeExtraSmall,
                              ),
                            ),
                          ],
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
                            const Icon(
                              Icons.close,
                              size: Dimensions.fontSizeDefault,
                            ),
                            Text(
                              '${getQuantityOfProduct(itemId: product.id!)}',
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
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        loadingRemove = true;
                      });
                      await FirebaseDatabaseHelper()
                          .deleteProductToCart(
                        product: product,
                      )
                          .then((done) {
                        if (done) {
                          setState(() {
                            totalPrice = totalPrice -
                                ((product.price! - product.discount!) *
                                    getQuantityOfProduct(itemId: product.id!));
                            totalItems = totalItems -
                                getQuantityOfProduct(itemId: product.id!);
                            _cartItems.removeWhere(
                                (element) => element.id == product.id);
                          });
                        }
                        setState(() {
                          loadingRemove = false;
                        });
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: loadingRemove
                          ? Image.asset(
                              Images.loading,
                              width: 20,
                            )
                          : const Text(
                              'Remove',
                              style: TextStyle(
                                color: AppThemeColor.dullFontColor,
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerView() {
    return GestureDetector(
      onTap: () => RouterClass().profileScreenRoute(context: context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'My ',
              style: TextStyle(
                fontSize: Dimensions.paddingSizeExtraLarge,
                fontWeight: FontWeight.w700,
                color: AppThemeColor.orangeColor,
              ),
            ),
            const Text(
              'Cart',
              style: TextStyle(
                fontSize: Dimensions.paddingSizeExtraLarge,
                fontWeight: FontWeight.w700,
                color: AppThemeColor.greenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makeCheckOut() async {
    await FirebaseDatabaseHelper()
        .addCheckout(
      checkOutObject: CheckOutObject(
        totalPrice: totalPrice,
        totalItems: totalItems,
        customerUid: widget.customer.uid!,
        customerPhoneNumber: widget.customer.phoneNumber!,
        customerName: widget.customer.name!,
        items: _cartItems,
      ),
    )
        .then((orderId) async {
      if (orderId != null) {
        await FirebaseDatabaseHelper().clearCart().then((done) {
          if (done) {
            print('Order: $orderId Successful!');
            RouterClass().successScreenRoute(
              context: context,
              customer: widget.customer,
            );
          }
        });
      }
    });
  }
}
