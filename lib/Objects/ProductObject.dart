import 'package:image_picker/image_picker.dart';

class ProductObject {
  String? id, title;
  String? imageLink;
  String? imageName;
  XFile? productImage;

  String? shortDescription, selectedCategoryId, selectedCategoryName;

  double? price, discount, sequence;

  ProductObject({
    this.id,
    required this.title,
    this.imageLink,
    this.imageName,
    this.productImage,
    this.shortDescription,
    this.selectedCategoryId,
    this.selectedCategoryName,
    this.price,
    this.discount,
    this.sequence,
  });

  factory ProductObject.fromJson(Map<dynamic, dynamic> json) {
    print('ProductObject DATA GETTING $json');
    return ProductObject(
      id: json['id'],
      title: json['title'] ?? '',
      imageName: json['imageName'] ?? '',
      imageLink: json['imageLink'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      selectedCategoryId: json['selectedCategoryId'] ?? '',
      selectedCategoryName: json['selectedCategoryName'] ?? '',
      price: double.parse(json['price'].toString()),
      discount: double.parse(json['discount'].toString()),
      sequence: double.parse(json['sequence'].toString()),
    );
  }

  Map<String, dynamic> toJson({required String productId}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = productId;
    data['title'] = title;
    data['imageLink'] = imageLink;
    data['imageName'] = imageName;
    data['shortDescription'] = shortDescription;
    data['selectedCategoryId'] = selectedCategoryId;
    data['selectedCategoryName'] = selectedCategoryName;
    data['price'] = price;
    data['discount'] = discount;
    data['sequence'] = sequence;
    return data;
  }
}
