import 'package:url_launcher/url_launcher.dart' as url_launcher;

class UriLaunching {
  static Future<bool> launch(Uri uri) async {
    if (await url_launcher.canLaunchUrl(uri)) {
      return await url_launcher.launchUrl(uri);
    }
    return false;
  }
}
