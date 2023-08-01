import 'package:image_picker/image_picker.dart';

class CategoryObject {
  String? id, title;
  String? imageLink;
  String? imageName;
  XFile? categoryImage;

  CategoryObject({
    this.id,
    required this.title,
    this.imageLink,
    this.imageName,
    this.categoryImage,
  });

  factory CategoryObject.fromJson(Map<dynamic, dynamic> json) {
    print('CategoryObject DATA GETTING $json');
    return CategoryObject(
      id: json['id'],
      title: json['title'] ?? '',
      imageName: json['imageName'] ?? '',
      imageLink: json['imageLink'] ?? '',
    );
  }

  Map<String, dynamic> toJson({required String bannerId}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = bannerId;
    data['title'] = title;
    data['imageLink'] = imageLink;
    data['imageName'] = imageName;
    return data;
  }
}
