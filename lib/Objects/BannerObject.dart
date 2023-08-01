import 'package:image_picker/image_picker.dart';

class BannerObject {
  String? id, title;
  String? imageLink;
  String? imageName;
  XFile? bannerImage;

  BannerObject({
    this.id,
    required this.title,
    this.imageLink,
    this.imageName,
    this.bannerImage,
  });

  factory BannerObject.fromJson(Map<dynamic, dynamic> json) {
    print('BannerObject DATA GETTING $json');
    return BannerObject(
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
