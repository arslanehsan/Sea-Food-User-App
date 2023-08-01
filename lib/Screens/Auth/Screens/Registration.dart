import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seefood/Screens/Auth/Firebase/FirebaseDatabaseService.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';
import 'package:seefood/Utils/AppConstents.dart';
import 'package:seefood/Utils/Colors.dart';
import 'package:seefood/Utils/Images.dart';
import 'package:seefood/Utils/Router.dart';
import 'package:seefood/Utils/Toast.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool passwordVisible = true;
  bool termsConditions = false;
  bool _buttonLoading = false;

  final CustomerObject _customer = CustomerObject();

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
          child: Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          goBack();
                        },
                        child: const Icon(
                          Icons.keyboard_double_arrow_left,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const Text(
                        'Registration',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 40),
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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _key,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                // controller: firstName,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Name';
                                  }
                                  return null;
                                },
                                onSaved: (name) {
                                  setState(() {
                                    _customer.name = name;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: 'First Name',
                                    labelText: 'First Name',
                                    // hintStyle:
                                    //     const TextStyle(color: darkMehroonColor),
                                    // labelStyle:
                                    //     const TextStyle(color: AppThemeColor.orangeColor),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppThemeColor.orangeColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: AppThemeColor.orangeColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                // controller: phoneNumber,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Phone Number';
                                  }
                                  return null;
                                },
                                onSaved: (phone) {
                                  setState(() {
                                    _customer.phoneNumber = phone;
                                  });
                                },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    hintText: 'Phone Number',
                                    labelText: 'Phone Number',
                                    // hintStyle:
                                    //     const TextStyle(color: darkMehroonColor),
                                    // labelStyle:
                                    //     const TextStyle(color: AppThemeColor.orangeColor),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppThemeColor.orangeColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    prefixIcon: Icon(
                                      Platform.isAndroid
                                          ? Icons.android
                                          : Icons.phone_iphone,
                                      color: AppThemeColor.orangeColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                // controller: emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Email Address';
                                  } else if (!RegExp(r'\S+@\S+\.\S+')
                                      .hasMatch(value)) {
                                    return "Please Enter a Valid Email";
                                  }
                                  return null;
                                },
                                onSaved: (email) {
                                  setState(() {
                                    _customer.email = email;
                                  });
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    labelText: 'Email',
                                    // hintStyle:
                                    //     const TextStyle(color: darkMehroonColor),
                                    // labelStyle:
                                    //     const TextStyle(color: AppThemeColor.orangeColor),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppThemeColor.orangeColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: AppThemeColor.orangeColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: TextFormField(
                                // controller: password,
                                validator: (value) {
                                  if (value!.isEmpty && value.length < 8) {
                                    return 'Enter Password';
                                  }
                                  return null;
                                },
                                onSaved: (password) {
                                  setState(() {
                                    _customer.password = password;
                                  });
                                },
                                keyboardType: TextInputType.text,
                                obscureText: passwordVisible,
                                obscuringCharacter: '●',
                                decoration: InputDecoration(
                                    hintText: '●●●●●●●●',
                                    labelText: 'Password',
                                    hintStyle: const TextStyle(
                                        // color: darkMehroonColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    // labelStyle:
                                    //     const TextStyle(color: AppThemeColor.orangeColor),
                                    focusColor: AppThemeColor.orangeColor,
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: AppThemeColor.orangeColor,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppThemeColor.orangeColor,
                                          width: 2.0),
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
                                        color: AppThemeColor.orangeColor,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Checkbox(
                                      activeColor: AppThemeColor.orangeColor,
                                      value: termsConditions,
                                      onChanged: (check) {
                                        setState(() {
                                          termsConditions = check!;
                                        });
                                      }),
                                  const Text('Agreed Terms And Conditions')
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _registerCustomer();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 55,
                                decoration: BoxDecoration(
                                  gradient: AppThemeColor.backgroundGradient1,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: _buttonLoading
                                    ? Image.asset(Images.loading)
                                    : const Text(
                                        'Register',
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

  Future<void> _registerCustomer() async {
    // print(FirebaseAuth.instance.currentUser!.email);
    try {
      if (_key.currentState!.validate()) {
        if (termsConditions) {
          setState(() {
            _buttonLoading = true;
          });
          _key.currentState!.save();
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _customer.email!, password: _customer.password!)
              .then((customerValue) async {
            setState(() {
              _customer.uid = customerValue.user!.uid;
            });
            await AuthFirebaseDatabaseService()
                .createNewCustomer(customer: _customer)
                .then((done) {
              if (done) {
                setState(() {
                  _buttonLoading = false;
                });
                RouterClass().userHomeScreenRoute(context: context);
                ShowToast().showNormalToast(
                    msg: 'Welcome To ${AppConstents.appName}!');
              } else {
                setState(() {
                  _buttonLoading = false;
                });
              }
            });
          });
        } else {
          ShowToast().showNormalToast(msg: 'Please check TERMS & CONDITIONS!');
        }
      }
    } on FirebaseAuthException catch (e) {
      // print(e.code);
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          ShowToast()
              .showNormalToast(msg: "Email already used. Go to login page.");
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          ShowToast().showNormalToast(msg: "Wrong email/password combination.");
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          ShowToast().showNormalToast(msg: "No user found with this email.");
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          ShowToast().showNormalToast(msg: "User disabled.");
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          ShowToast().showNormalToast(
              msg: "Too many requests to log into this account.");
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          ShowToast()
              .showNormalToast(msg: "Server error, please try again later.");
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          ShowToast().showNormalToast(msg: "Email address is invalid.");
          break;
        default:
          ShowToast().showNormalToast(msg: "An undefined Error happened.");
      }
      setState(() {
        _buttonLoading = false;
      });
    } catch (e) {
      setState(() {
        _buttonLoading = false;
      });
    } finally {
      setState(() {
        _buttonLoading = false;
      });
    }
  }

  goBack() {
    Navigator.pop(context);
  }
}
