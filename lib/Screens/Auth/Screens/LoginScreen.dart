// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seefood/Utils/Colors.dart';
import 'package:seefood/Utils/Images.dart';
import 'package:seefood/Utils/Router.dart';
import 'package:seefood/Utils/dimensions.dart';

import '../../../Utils/Toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _key = GlobalKey();
  bool passwordVisible = true;
  bool buttonLoading = false;
  TextEditingController emailAddress = TextEditingController();
  TextEditingController passwordEdtControlor = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      passwordVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppThemeColor.backgroundGradient1,
        ),
        child: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                // Container(
                //   alignment: Alignment.centerLeft,
                //   padding: const EdgeInsets.only(left: 10, top: 10),
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //     child: Container(
                //       alignment: Alignment.center,
                //       height: 40,
                //       width: 40,
                //       child: const Icon(
                //         Icons.keyboard_double_arrow_left,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const Text(
                    'Welcome to Login',
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
                  // child: const Image(
                  //   image: AssetImage(Images.inAppLogo),
                  //   fit: BoxFit.cover,
                  // ),
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
                          key: _key,
                          child: SingleChildScrollView(
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
                                        //     color: AppThemeColor.orangeColor),
                                        // labelStyle: const TextStyle(
                                        //     color: AppThemeColor.yellowColor),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppThemeColor.yellowColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.email,
                                          color: AppThemeColor.yellowColor,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        )),
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
                                      if (value == null && value!.length < 8) {
                                        return 'Enter Valid Password';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: '●●●●●●●●',
                                        labelText: 'Password',
                                        hintStyle: const TextStyle(
                                            color: AppThemeColor.orangeColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        labelStyle: const TextStyle(
                                            color: AppThemeColor.yellowColor),
                                        focusColor: AppThemeColor.yellowColor,
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: AppThemeColor.yellowColor,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppThemeColor.yellowColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        )),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _loginCustomer();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 55,
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppThemeColor.yellowColor,
                                            AppThemeColor.orangeColor
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: buttonLoading
                                        ? Image.asset('images/loading.gif')
                                        : const Text(
                                            'Login',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => RouterClass()
                                      .forgetPasswordScreenRoute(
                                          context: context),
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    alignment: Alignment.centerRight,
                                    child: const Text(
                                      'Forget Password',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppThemeColor.pureBlackColor,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => RouterClass()
                                      .signupScreenRoute(context: context),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: const Text(
                                      'I Don\'t Have Account',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppThemeColor.greenColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }

  Future<void> _loginCustomer() async {
    try {
      if (_key.currentState!.validate()) {
        String email = emailAddress.text, password = passwordEdtControlor.text;
        setState(() {
          buttonLoading = true;
        });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((customer) {
          setState(() {
            buttonLoading = false;
          });
          RouterClass().userHomeScreenRoute(context: context);
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          ShowToast().showNormalToast(
              msg: "Your email address appears to be malformed.");
          break;
        case "ERROR_WRONG_PASSWORD":
          ShowToast().showNormalToast(msg: "Your password is wrong.");
          break;
        case "ERROR_USER_NOT_FOUND":
          ShowToast()
              .showNormalToast(msg: "User with this email doesn't exist.");
          break;
        case "ERROR_USER_DISABLED":
          ShowToast()
              .showNormalToast(msg: "User with this email has been disabled.");
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          ShowToast()
              .showNormalToast(msg: "Too many requests. Try again later.");
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          ShowToast().showNormalToast(
              msg: "Signing in with Email and Password is not enabled.");
          break;
        default:
          ShowToast().showNormalToast(msg: "An undefined Error happened.");
      }
      setState(() {
        buttonLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        buttonLoading = false;
      });
    }
  }
}
