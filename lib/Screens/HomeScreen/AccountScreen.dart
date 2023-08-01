import 'package:flutter/material.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';
import 'package:seefood/Utils/Images.dart';

import '../../Utils/Colors.dart';
import '../../Utils/Router.dart';
import '../../Utils/dimensions.dart';

class AccountScreen extends StatefulWidget {
  final CustomerObject customer;
  const AccountScreen({
    super.key,
    required this.customer,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final _screenWidth = MediaQuery.of(context).size.width;
  late final _screenHeight = MediaQuery.of(context).size.height;
  late final CustomerObject _customer = widget.customer;

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      decoration: const BoxDecoration(
        color: AppThemeColor.backGroundColor,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 15),
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(80),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(Images.inAppLogo),
                ),
              ),
              // child: const Image(
              //   image: AssetImage(Images.inAppLogo),
              //   fit: BoxFit.cover,
              // ),
            ),
            Text(
              _customer.name!,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: Dimensions.fontSizeExtraLarge,
              ),
            ),
            Text(
              _customer.phoneNumber!,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: Dimensions.fontSizeExtraLarge,
                color: AppThemeColor.dullFontColor,
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () =>
                      RouterClass().profileScreenRoute(context: context),
                  child: _singleTabView(
                    iconData: Icons.person,
                    title: 'Profile',
                  ),
                ),
                GestureDetector(
                  // onTap: () =>
                  //     RouterClass().faqsScreenRoute(context: context),
                  child: _singleTabView(
                    iconData: Icons.help_outline,
                    title: 'About Us',
                  ),
                ),
                GestureDetector(
                  // onTap: () => RouterClass()
                  //     .inviteFriendScreenRoute(context: context),
                  child: _singleTabView(
                    iconData: Icons.policy,
                    title: 'Privacy Policy',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 90,
            ),
          ],
        ),
      ),
    );
  }

  Widget _singleTabView({
    required IconData iconData,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                size: 22,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: const TextStyle(
                  color: AppThemeColor.pureBlackColor,
                  fontWeight: FontWeight.w400,
                  fontSize: Dimensions.fontSizeLarge,
                ),
              )
            ],
          ),
          const Icon(
            Icons.keyboard_arrow_right_rounded,
            color: AppThemeColor.pureBlackColor,
            size: 28,
          )
        ],
      ),
    );
  }
}
