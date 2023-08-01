import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';
import 'package:seefood/Utils/Router.dart';
import 'package:seefood/Utils/dimensions.dart';

import '../../Objects/CheckOutObject.dart';
import '../../Objects/ProductObject.dart';
import '../../Utils/Colors.dart';

class SingleOrderHistoryScreen extends StatefulWidget {
  final List<ProductObject> products;
  final CustomerObject customer;
  final CheckOutObject singleOrder;
  const SingleOrderHistoryScreen({
    super.key,
    required this.products,
    required this.customer,
    required this.singleOrder,
  });

  @override
  State<SingleOrderHistoryScreen> createState() =>
      _SingleOrderHistoryScreenState();
}

class _SingleOrderHistoryScreenState extends State<SingleOrderHistoryScreen> {
  late final double _screenHeight = MediaQuery.of(context).size.height;
  late final double _screenWidth = MediaQuery.of(context).size.width;

  late final CheckOutObject currentOrder = widget.singleOrder;

  bool loadingRemove = false;

  late final List<ProductObject> _products = widget.products;

  List<ProductObject> _getSortedProducts() {
    List<ProductObject> productListData = [];
    for (var singleProduct in _products) {
      for (var element in currentOrder.items!) {
        if (element.id == singleProduct.id) {
          productListData.add(singleProduct);
        }
      }
    }
    return productListData;
  }

  int getQuantityOfProduct({required String itemId}) {
    int quantity = 0;
    for (var element in currentOrder.items!) {
      if (itemId == element.id) {
        quantity = element.quantity;
      }
    }
    return quantity;
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
                _productsView(),
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
                '\$${currentOrder.totalPrice}',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Products',
                style: TextStyle(
                  color: AppThemeColor.pureBlackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
              Text(
                '${currentOrder.totalItems}',
                style: const TextStyle(
                  color: AppThemeColor.dullFontColor,
                  fontWeight: FontWeight.w500,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order at',
                style: TextStyle(
                  color: AppThemeColor.pureBlackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
              Text(
                DateFormat('dd MMM, yyyy - kk:mm a')
                    .format(currentOrder.orderTime!),
                style: const TextStyle(
                  color: AppThemeColor.dullFontColor,
                  fontWeight: FontWeight.w500,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Status',
                style: TextStyle(
                  color: AppThemeColor.pureBlackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
              Text(
                currentOrder.status!.toUpperCase(),
                style: const TextStyle(
                  color: AppThemeColor.orangeColor,
                  fontWeight: FontWeight.w500,
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
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
    double tabWidth = _screenWidth;
    return GestureDetector(
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
              'Order ',
              style: TextStyle(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w700,
                color: AppThemeColor.orangeColor,
              ),
            ),
            Text(
              currentOrder.orderId!,
              style: const TextStyle(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w700,
                color: AppThemeColor.greenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
