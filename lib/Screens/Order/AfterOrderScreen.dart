import 'package:flutter/material.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';
import 'package:seefood/Utils/Colors.dart';
import 'package:seefood/Utils/Router.dart';

import '../../Utils/dimensions.dart';

class AfterOrderScreen extends StatefulWidget {
  final CustomerObject customer;
  const AfterOrderScreen({super.key, required this.customer});

  @override
  State<AfterOrderScreen> createState() => _AfterOrderScreenState();
}

class _AfterOrderScreenState extends State<AfterOrderScreen> {
  late final _screenWidth = MediaQuery.of(context).size.width;
  late final _screenHeight = MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: _screenWidth,
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.check_circle,
            size: _screenWidth / 2,
            color: AppThemeColor.greenColor,
          ),
          Text(
            'Your Order is Successful! ${widget.customer.name!}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: Dimensions.fontSizeOverLarge,
              fontWeight: FontWeight.w500,
              color: AppThemeColor.orangeColor,
            ),
          ),
          Text(
            'Our agent will contact you on ${widget.customer.phoneNumber} soon to make order confirm',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.w400,
              color: AppThemeColor.dullFontColor,
            ),
          ),
          InkWell(
            onTap: () => RouterClass().afterOrderRest(context: context),
            child: Container(
              width: _screenWidth,
              decoration: BoxDecoration(
                color: AppThemeColor.greenColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                'Go Home',
                style: TextStyle(
                  color: AppThemeColor.pureWhiteColor,
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
