class CartItemObject {
  String id;
  int quantity;

  CartItemObject({
    required this.id,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }

  factory CartItemObject.fromJson(Map<dynamic, dynamic> json) {
    return CartItemObject(
      id: json['id'],
      quantity: json['quantity'],
    );
  }

  static dynamic getListMap(List<dynamic> items) {
    List<Map<String, dynamic>> list = [];
    for (var element in items) {
      list.add(element.toMap());
    }
    return list;
  }

  static dynamic getObjectListFromMap(Map<String, dynamic> items) {
    List<CartItemObject> list = [];
    items.forEach((key, value) {
      list.add(CartItemObject.fromJson(value));
    });
    return list;
  }

  static dynamic getObjectListFromList(List<dynamic> items) {
    List<CartItemObject> list = [];
    items.forEach((value) {
      list.add(CartItemObject.fromJson(value));
    });
    return list;
  }
}
