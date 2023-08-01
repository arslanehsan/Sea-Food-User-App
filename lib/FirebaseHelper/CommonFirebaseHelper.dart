import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:seefood/Objects/CartItemObject.dart';
import 'package:seefood/Objects/CheckOutObject.dart';

import '../Objects/AppSettingsObject.dart';
import '../Objects/BannerObject.dart';
import '../Objects/CategoryObject.dart';
import '../Objects/LikedObject.dart';
import '../Objects/ProductObject.dart';

class FirebaseDatabaseHelper {
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  Future<AppSettingsObject?> getAppSettings() async {
    AppSettingsObject? appSettings;

    final topUserPostsRef = FirebaseDatabase.instance.ref('AppSettings');
    try {
      await topUserPostsRef.once().then((snapshot) {
        Map<String, dynamic>? value =
            snapshot.snapshot.value as Map<String, dynamic>?;
        if (value != null) {
          appSettings = AppSettingsObject.fromJson(value);
        }
      });

      return appSettings;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<BannerObject>> getBanners() async {
    List<BannerObject> bannersData = [];
    DatabaseReference dbf = firebaseDatabase.ref().child('Banners');

    await dbf.once().then((snapshot) {
      print(snapshot.snapshot.value);
      Map<dynamic, dynamic>? value =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      if (value != null) {
        value.forEach((key, values) {
          BannerObject banner = BannerObject.fromJson(values);

          bannersData.add(banner);
        });
      }
    });
    return bannersData;
    // ..sort((a, b) => a.brandSequence.compareTo(b.brandSequence));
  }

  Future<List<CategoryObject>> getCategories() async {
    List<CategoryObject> categoriesData = [];
    DatabaseReference dbf = firebaseDatabase.ref().child('Categories');

    await dbf.once().then((snapshot) {
      Map<dynamic, dynamic>? value =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      if (value != null) {
        value.forEach((key, values) {
          CategoryObject category = CategoryObject.fromJson(values);

          categoriesData.add(category);
        });
      }
    });
    return categoriesData;
    // ..sort((a, b) => a.brandSequence.compareTo(b.brandSequence));
  }

  Future<List<ProductObject>> getProducts() async {
    List<ProductObject> productsData = [];
    DatabaseReference dbf = firebaseDatabase.ref().child('Products');

    await dbf.once().then((snapshot) {
      Map<dynamic, dynamic>? value =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      if (value != null) {
        value.forEach((key, values) {
          ProductObject product = ProductObject.fromJson(values);

          productsData.add(product);
        });
      }
    });
    return productsData..sort((a, b) => a.sequence!.compareTo(b.sequence!));
  }

  Future<bool> addProductLike({required ProductObject product}) async {
    DatabaseReference dbf = firebaseDatabase.ref();
    bool done = false;
    User userData = FirebaseAuth.instance.currentUser!;
    try {
      Map<String, dynamic> data = {
        'liked': true,
      };
      await dbf
          .child('Likes')
          .child(userData.uid)
          .child(product.id!)
          .set(data)
          .then((value) {
        done = true;
      });

      return done;
    } catch (e) {
      print("Like Product Error");
      print(e);
      return false;
    }
  }

  Future<bool> removeProductLike({required ProductObject product}) async {
    DatabaseReference dbf = firebaseDatabase.ref();
    bool done = false;
    User userData = FirebaseAuth.instance.currentUser!;
    try {
      await dbf
          .child('Likes')
          .child(userData.uid)
          .child(product.id!)
          .remove()
          .then((value) {
        done = true;
      });

      return done;
    } catch (e) {
      print("DisLike Product Error");
      print(e);
      return false;
    }
  }

  Future<bool> getProductLiked({required ProductObject product}) async {
    bool liked = false;
    User userData = FirebaseAuth.instance.currentUser!;
    DatabaseReference dbf = firebaseDatabase
        .ref()
        .child('Likes')
        .child(userData.uid)
        .child(product.id!)
        .child('liked');
    await dbf.once().then((snapshot) {
      print('liked: ${snapshot.snapshot.value}');
      if (snapshot.snapshot.value != null) {
        liked = snapshot.snapshot.value as bool;
      }
    });
    return liked;
  }

  Future<List<LikedObject>> getLikedProducts() async {
    List<LikedObject> productsData = [];
    User userData = FirebaseAuth.instance.currentUser!;
    DatabaseReference dbf =
        firebaseDatabase.ref().child('Likes').child(userData.uid);

    await dbf.once().then((snapshot) {
      Map<dynamic, dynamic>? value =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      if (value != null) {
        value.forEach((key, values) {
          print(values['liked']);
          LikedObject product = LikedObject(id: key, liked: values['liked']);

          productsData.add(product);
        });
      }
    });
    return productsData;
  }

  Future<bool> addProductToCart(
      {required ProductObject product, required int quantity}) async {
    DatabaseReference dbf = firebaseDatabase.ref();
    bool done = false;
    User userData = FirebaseAuth.instance.currentUser!;
    try {
      Map<String, dynamic> data = {
        'quantity': quantity,
      };
      await dbf
          .child('Carts')
          .child(userData.uid)
          .child(product.id!)
          .set(data)
          .then((value) {
        done = true;
      });

      return done;
    } catch (e) {
      print("Add Cart Item Error");
      print(e);
      return false;
    }
  }

  Future<bool> deleteProductToCart({required ProductObject product}) async {
    DatabaseReference dbf = firebaseDatabase.ref();
    bool done = false;
    User userData = FirebaseAuth.instance.currentUser!;
    try {
      await dbf
          .child('Carts')
          .child(userData.uid)
          .child(product.id!)
          .remove()
          .then((value) {
        done = true;
      });

      return done;
    } catch (e) {
      print("Remove Cart Item Error");
      print(e);
      return false;
    }
  }

  Future<bool> clearCart() async {
    DatabaseReference dbf = firebaseDatabase.ref();
    bool done = false;
    User userData = FirebaseAuth.instance.currentUser!;
    try {
      await dbf.child('Carts').child(userData.uid).remove().then((value) {
        done = true;
      });

      return done;
    } catch (e) {
      print("Remove Cart Item Error");
      print(e);
      return false;
    }
  }

  Future<List<CartItemObject>> getCartItems() async {
    List<CartItemObject> productsData = [];
    User userData = FirebaseAuth.instance.currentUser!;
    DatabaseReference dbf =
        firebaseDatabase.ref().child('Carts').child(userData.uid);

    await dbf.once().then((snapshot) {
      Map<dynamic, dynamic>? value =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      if (value != null) {
        value.forEach((key, values) {
          print(values['liked']);
          CartItemObject product =
              CartItemObject(id: key, quantity: values['quantity']);

          productsData.add(product);
        });
      }
    });
    return productsData;
  }

  Future<String?> addCheckout({
    required CheckOutObject checkOutObject,
  }) async {
    DatabaseReference dbf = firebaseDatabase.ref();
    String orderId = dbf.child('Orders').push().key!;
    try {
      await dbf.child('Orders').child(orderId).set(
            checkOutObject.toMap(),
          );

      return orderId;
    } catch (e) {
      print("Add Order Error");
      print(e);
      return null;
    }
  }

  Future<List<CheckOutObject>> getOrdersHistory() async {
    List<CheckOutObject> checkoutsData = [];
    User userData = FirebaseAuth.instance.currentUser!;
    final dbf = firebaseDatabase
        .ref()
        .child('Orders')
        .orderByChild('customerUid')
        .equalTo(
          userData.uid,
        );

    await dbf.once().then((snapshot) {
      Map<dynamic, dynamic>? value =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      if (value != null) {
        checkoutsData = CheckOutObject.getObjectList(value);
      }
    });
    return checkoutsData..sort((a, b) => b.orderTime!.compareTo(a.orderTime!));
  }
}
