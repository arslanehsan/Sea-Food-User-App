import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seefood/Utils/Colors.dart';
import 'package:seefood/Utils/Router.dart';
import 'package:seefood/Utils/Toast.dart';
import 'package:seefood/Utils/dimensions.dart';

import '../../../Utils/Images.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController emailAddress = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            gradient: AppThemeColor.backgroundGradient1,
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 40,
                    child: const Icon(
                      Icons.keyboard_double_arrow_left,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 5),
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: Colors.white),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 50),
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
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: SingleChildScrollView(
                      child: Form(
                        key: key,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: TextFormField(
                                controller: emailAddress,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Enter Email';
                                  } else if (!RegExp(r'\S+@\S+\.\S+')
                                      .hasMatch(value)) {
                                    return "Please Enter a Valid Email";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    labelText: 'Email',
                                    // hintStyle: const TextStyle(
                                    //     color: darkMehroonColor),
                                    // labelStyle: const TextStyle(
                                    //     color: AppThemeColor.yellowColor),
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
                              onTap: () async {
                                if (key.currentState!.validate()) {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: emailAddress.text)
                                      .then((value) {
                                    ShowToast().showNormalToast(
                                        msg: 'Please Check Your Email!');
                                    RouterClass().appRest(context: context);
                                  });
                                }
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
                                child: const Text(
                                  'Recover Password',
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

  goBack() {
    Navigator.pop(context);
  }
}
