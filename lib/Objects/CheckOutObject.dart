import 'package:seefood/Objects/CartItemObject.dart';

class CheckOutObject {
  String? orderId;
  double totalPrice;
  int totalItems;
  String customerUid;
  String customerPhoneNumber;
  String customerName;
  List<CartItemObject>? items;

  String? status;
  DateTime? orderTime;

  CheckOutObject({
    this.orderId,
    this.status,
    this.orderTime,
    required this.totalPrice,
    required this.totalItems,
    required this.customerUid,
    required this.customerPhoneNumber,
    required this.customerName,
    required this.items,
  });

  factory CheckOutObject.fromJson(Map<dynamic, dynamic> json, String orderId) {
    print('CheckOutObject data: ${json['items']}');
    return CheckOutObject(
      orderId: orderId,
      status: json['status'],
      orderTime: DateTime.parse(json['orderTime']),
      totalPrice: double.parse(json['totalPrice'].toString()),
      totalItems: json['totalItems'],
      customerUid: json['customerUid'],
      customerPhoneNumber: json['customerPhoneNumber'],
      customerName: json['customerName'],
      items: CartItemObject.getObjectListFromList(json['items']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'totalPrice': totalPrice,
      'totalItems': totalItems,
      'customerUid': customerUid,
      'customerPhoneNumber': customerPhoneNumber,
      'customerName': customerName,
      'status': 'pending',
      'orderTime': DateTime.now().toString(),
      'items': CartItemObject.getListMap(items!),
    };
  }

  static dynamic getListMap(List<dynamic> items) {
    List<Map<String, dynamic>> list = [];
    for (var element in items) {
      list.add(element.toMap());
    }
    return list;
  }

  static dynamic getObjectList(Map<dynamic, dynamic> items) {
    List<CheckOutObject> list = [];
    items.forEach((key, value) {
      list.add(CheckOutObject.fromJson(value, key));
    });
    return list;
  }
}
