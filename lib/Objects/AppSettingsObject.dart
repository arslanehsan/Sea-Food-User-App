import 'package:image_picker/image_picker.dart';

class AppSettingsObject {
  String? appTitle, appVersion, privacyPolicyLink, aboutUsLink;
  String? inAppIconLink;
  String? inAppIconName;
  XFile? inAppIcon;

  AppSettingsObject({
    this.appTitle,
    this.appVersion,
    this.privacyPolicyLink,
    this.aboutUsLink,
    this.inAppIconLink,
    this.inAppIconName,
    this.inAppIcon,
  });

  factory AppSettingsObject.fromJson(Map<String, dynamic> json) {
    print('AppSettingsObject DATA GETTING $json');
    return AppSettingsObject(
      appTitle: json['appTitle'],
      appVersion: json['appVersion'] ?? '',
      privacyPolicyLink: json['privacyPolicyLink'] ?? '',
      aboutUsLink: json['aboutUsLink'] ?? '',
      inAppIconLink: json['inAppIconLink'] ?? '',
      inAppIconName: json['inAppIconName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appTitle'] = appTitle;
    data['appVersion'] = appVersion;
    data['privacyPolicyLink'] = privacyPolicyLink;
    data['aboutUsLink'] = aboutUsLink;
    data['inAppIconName'] = inAppIconName;
    data['inAppIconLink'] = inAppIconLink;
    return data;
  }
}
