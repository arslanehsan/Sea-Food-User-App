import 'package:flutter/material.dart';
import 'package:seefood/Objects/ProductObject.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';
import 'package:seefood/Screens/Auth/Screens/ForgetPassword.dart';
import 'package:seefood/Screens/Auth/Screens/LoginScreen.dart';
import 'package:seefood/Screens/Auth/Screens/ProfileScreen.dart';
import 'package:seefood/Screens/Auth/Screens/Registration.dart';
import 'package:seefood/Screens/HomeScreen/HomeScreen.dart';
import 'package:seefood/Screens/HomeScreen/SingleProductView.dart';
import 'package:seefood/Screens/Order/AfterOrderScreen.dart';
import 'package:seefood/Screens/Order/CartScreen.dart';

import '../Objects/CheckOutObject.dart';
import '../Screens/Order/SingleOrderHistoryScreen.dart';

class RouterClass {
  appRest({required BuildContext context}) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false);

  afterOrderRest({required BuildContext context}) =>
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const UserHomeScreen(),
          ),
          (route) => false);

  loginScreenRoute({required BuildContext context}) =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );

  signupScreenRoute({required BuildContext context}) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Registration(),
        ),
      );

  forgetPasswordScreenRoute({required BuildContext context}) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ForgetPassword(),
        ),
      );

  profileScreenRoute({required BuildContext context}) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );

  userHomeScreenRoute({required BuildContext context}) =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserHomeScreen(),
        ),
      );

  singleProductScreenRoute({
    required BuildContext context,
    required ProductObject product,
    required CustomerObject customer,
    required List<ProductObject> products,
  }) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleProductView(
            product: product,
            products: products,
            customer: customer,
          ),
        ),
      );

  cartScreenRoute(
          {required BuildContext context,
          required List<ProductObject> products,
          required CustomerObject customer}) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartScreen(
            products: products,
            customer: customer,
          ),
        ),
      );
  singleOrderHistoryScreenRoute({
    required BuildContext context,
    required List<ProductObject> products,
    required CustomerObject customer,
    required CheckOutObject singleOrder,
  }) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleOrderHistoryScreen(
            products: products,
            customer: customer,
            singleOrder: singleOrder,
          ),
        ),
      );

  successScreenRoute(
          {required BuildContext context, required CustomerObject customer}) =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AfterOrderScreen(
            customer: customer,
          ),
        ),
      );
}
