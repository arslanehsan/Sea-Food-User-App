import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:seefood/Screens/Auth/Firebase/FirebaseDatabaseService.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';
import 'package:seefood/Utils/Colors.dart';
import 'package:seefood/Utils/Router.dart';
import 'package:seefood/Utils/Toast.dart';

import '../../../Utils/Images.dart';
import '../../../Utils/dimensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  // TextEditingController password = TextEditingController();
  TextEditingController passwordEdtControlor = TextEditingController();

  CustomerObject? _customer;
  bool passwordVisible = true;

  bool _buttonLoading = false;

  Future<void> getProfile() async {
    await AuthFirebaseDatabaseService()
        .getCustomerProfile()
        .then((customerData) {
      if (customerData != null) {
        firstName.text = customerData.name!;
        emailAddress.text = customerData.phoneNumber!;
        phoneNumber.text = customerData.email!;
        setState(() {
          _customer = customerData;
        });
      }
    });
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppThemeColor.backgroundGradient2,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _headerView(),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 40),
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60)),
                child: const Image(
                  image: AssetImage(Images.inAppLogo),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Container(
                    width: 450,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: SingleChildScrollView(
                      child: Form(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: firstName,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    hintText: 'First Name',
                                    labelText: 'First Name',
                                    enabled: false,
                                    // hintStyle:
                                    //     const TextStyle(color: AppThemeColor.orangeColor),
                                    // labelStyle:
                                    //     const TextStyle(color: AppThemeColor.yellowColor),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppThemeColor.yellowColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: AppThemeColor.yellowColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: phoneNumber,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    hintText: 'Phone Number',
                                    labelText: 'Phone Number',
                                    enabled: false,
                                    // hintStyle:
                                    //     const TextStyle(color: AppThemeColor.orangeColor),
                                    // labelStyle:
                                    //     const TextStyle(color: AppThemeColor.yellowColor),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppThemeColor.yellowColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    prefixIcon: Icon(
                                      kIsWeb
                                          ? Icons.phone_iphone
                                          : Platform.isAndroid
                                              ? Icons.android
                                              : Icons.phone_iphone,
                                      color: AppThemeColor.yellowColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: emailAddress,
                                keyboardType: TextInputType.emailAddress,
                                enabled: false,
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    labelText: 'Email',
                                    // hintStyle:
                                    //     const TextStyle(color: AppThemeColor.orangeColor),
                                    // labelStyle:
                                    //     const TextStyle(color: AppThemeColor.yellowColor),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppThemeColor.yellowColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: AppThemeColor.yellowColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDeleteProfileDialog();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                  top: 20,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 55,
                                decoration: BoxDecoration(
                                    gradient: AppThemeColor.backgroundGradient1,
                                    borderRadius: BorderRadius.circular(15)),
                                child: _buttonLoading
                                    ? Image.asset('images/loading.gif')
                                    : const Text(
                                        'Delete My Profile',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                FirebaseAuth.instance.signOut().then((value) {
                                  ShowToast().showNormalToast(
                                      msg:
                                          '${_customer!.name} Logout Successful!');
                                  RouterClass().appRest(context: context);
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                  top: 20,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 55,
                                decoration: BoxDecoration(
                                    gradient: AppThemeColor.backgroundGradient1,
                                    borderRadius: BorderRadius.circular(15)),
                                child: _buttonLoading
                                    ? Image.asset('images/loading.gif')
                                    : const Text(
                                        'Logout',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerView() {
    return GestureDetector(
      onTap: () => RouterClass().profileScreenRoute(context: context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppThemeColor.pureWhiteColor,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            if (_customer != null)
              Text(
                '${_customer!.name!}\'s ',
                style: const TextStyle(
                  fontSize: Dimensions.paddingSizeExtraLarge,
                  fontWeight: FontWeight.w700,
                  color: AppThemeColor.pureWhiteColor,
                ),
              ),
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: Dimensions.paddingSizeExtraLarge,
                fontWeight: FontWeight.w700,
                color: AppThemeColor.pureWhiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showDeleteProfileDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: _dialogView(),
          );
        });
  }

  Widget _dialogView() {
    return Container(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.triangleExclamation,
                size: 50,
                color: AppThemeColor.orangeColor,
              ),
              Text(
                'Hey ${_customer!.name!}\nAre you sure you want to delete your profile?',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                child: TextFormField(
                  controller: passwordEdtControlor,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: passwordVisible,
                  obscuringCharacter: '●',
                  validator: (value) {
                    if (value == null || value!.length < 8) {
                      print('validator called');
                      return 'Enter Valid Password';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: '●●●●●●●●',
                      labelText: 'Password',
                      hintStyle: const TextStyle(
                          color: AppThemeColor.orangeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      labelStyle:
                          const TextStyle(color: AppThemeColor.yellowColor),
                      focusColor: AppThemeColor.yellowColor,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: AppThemeColor.yellowColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppThemeColor.yellowColor, width: 2.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          passwordVisible
                              ? setState(() {
                                  passwordVisible = false;
                                })
                              : setState(() {
                                  passwordVisible = true;
                                });
                        },
                        child: Icon(
                          passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppThemeColor.yellowColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: AppThemeColor.pureBlackColor,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: _deleteProfileCalled,
                      color: AppThemeColor.yellowColor,
                      child: const Text(
                        "M Sure",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deleteProfileCalled() {
    if (_key.currentState!.validate()) {
      User? currentUserData = FirebaseAuth.instance.currentUser;
      if (currentUserData != null) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: currentUserData.email!,
                password: passwordEdtControlor.text)
            .then((value) {
          currentUserData.delete().then((value) {
            FirebaseAuth.instance.signOut().then((value) {
              RouterClass().appRest(context: context);
            });
          });
        });
      }
    }
  }

  goBack() {
    Navigator.pop(context);
  }
}
