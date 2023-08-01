import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seefood/FirebaseHelper/CommonFirebaseHelper.dart';
import 'package:seefood/Objects/CheckOutObject.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';
import 'package:seefood/Utils/Router.dart';

import '../../Objects/ProductObject.dart';
import '../../Utils/Colors.dart';
import '../../Utils/dimensions.dart';

class OrderHistoryScreen extends StatefulWidget {
  final CustomerObject customer;
  final List<ProductObject> products;
  const OrderHistoryScreen(
      {super.key, required this.customer, required this.products});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late final _screenWidth = MediaQuery.of(context).size.width;
  late final _screenHeight = MediaQuery.of(context).size.height;

  late final CustomerObject _customer = widget.customer;
  late final List<ProductObject> _products = widget.products;

  List<CheckOutObject> _orders = [];

  Future<void> getOrderHistory() async {
    await FirebaseDatabaseHelper().getOrdersHistory().then((ordersData) {
      print('orders: ${_orders.length}');
      setState(() {
        _orders = ordersData;
      });
    });
  }

  @override
  void initState() {
    getOrderHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
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
          _ordersView(),
        ],
      ),
    );
  }

  Widget _ordersView() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(bottom: 90),
        child: ListView.builder(
            itemCount: _orders.length,
            itemBuilder: (listContext, index) {
              return _singleOrderView(
                singleOrder: _orders[index],
              );
            }),
      ),
    );
  }

  Widget _singleOrderView({required CheckOutObject singleOrder}) {
    return GestureDetector(
      onTap: () => RouterClass().singleOrderHistoryScreenRoute(
        customer: widget.customer,
        context: context,
        products: _products,
        singleOrder: singleOrder,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: const BoxDecoration(
          color: AppThemeColor.pureWhiteColor,
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: AppThemeColor.pureBlackColor,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Order: # ',
                        style: TextStyle(
                          color: AppThemeColor.dullFontColor,
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        singleOrder.orderId!,
                        style: const TextStyle(
                          color: AppThemeColor.dullFontColor,
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Items: ',
                        style: TextStyle(
                          color: AppThemeColor.dullFontColor,
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        singleOrder.totalItems.toString(),
                        style: const TextStyle(
                          color: AppThemeColor.dullFontColor,
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        '${DateFormat('dd MMM, yyyy - kk:mm a').format(singleOrder.orderTime!)}   ',
                        style: const TextStyle(
                          color: AppThemeColor.dullFontColor,
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Total: \$${singleOrder.totalPrice} ',
                        style: const TextStyle(
                          color: AppThemeColor.dullFontColor,
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppThemeColor.orangeColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    singleOrder.status!.toUpperCase(),
                    style: const TextStyle(
                      color: AppThemeColor.pureWhiteColor,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.fontSizeExtraSmall,
                    ),
                  ),
                ),
                // const Icon(
                //   Icons.arrow_forward_ios_outlined,
                //   color: AppThemeColor.pureBlackColor,
                //   size: 22,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerView() {
    return GestureDetector(
      child: Container(
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
                  'Orders',
                  style: TextStyle(
                    fontSize: Dimensions.paddingSizeExtraLarge,
                    fontWeight: FontWeight.w700,
                    color: AppThemeColor.greenColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
