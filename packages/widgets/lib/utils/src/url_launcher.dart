import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:widgets/utils/utils.dart';

class UrlLauncher {
  /// @returns true if the url was launched
  /// @param emailAdress is the email adress to be launched
  static Future<bool> launchEmail(String emailAdress,
      [String? subject, String? body]) async {
    // normal email
    String uriString = 'mailto:$emailAdress';

    // add with subject
    if (subject != null) uriString += '?subject=$subject';
    // add with body
    if (body != null) uriString += '?body=$body';

    // parse the uri
    Uri uri = Uri.parse(uriString);
    return await _launchUrl(uri);
  }

  /// @returns true if the url was launched
  /// @param website is the website to be launched
  static Future<bool> launchBrowser(String website) async {
    Uri uri = Uri.parse('https://$website');
    return await _launchUrl(uri);
  }

  /// @returns true if the url was launched
  /// @param phoneNumber is the phone number to be called
  static Future<bool> launchPhone(String phoneNumber) async {
    Uri uri = Uri.parse('tel:$phoneNumber');
    return await _launchUrl(uri);
  }

  /// Launches the maps application for this platform.
  /// The maps application will show the result of the provided search [adress].
  /// Returns a Future that resolves to true if the maps application
  /// was launched successfully, false otherwise.
  /// Returns a [Uri] that can be launched on the current platform
  /// to open a maps application showing the result of a search query.
  static Future<bool> launchMaps(String adress) {
    Uri uri;

    if (kIsWeb) {
      uri = Uri.https(
          'www.google.com', '/maps/search/', {'api': '1', 'query': adress});
    } else if (Platform.isAndroid) {
      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': adress});
    } else if (Platform.isIOS) {
      uri = Uri.https('maps.apple.com', '/', {'q': adress});
    } else {
      uri = Uri.https(
          'www.google.com', '/maps/search/', {'api': '1', 'query': adress});
    }
    return _launchUrl(uri, url_launcher.LaunchMode.externalApplication);
  }

  /// Launches the maps application for this platform.
  /// The maps application will show the specified coordinates.
  /// Returns a Future that resolves to true if the maps application
  /// was launched successfully, false otherwise.
  /// Returns a [Uri] that can be launched on the current platform
  /// to open a maps application showing coordinates ([latitude] and [longitude]).
  static Future<bool> launchMapsCoordinates(double latitude, double longitude,
      [String? label]) {
    Uri uri;

    if (kIsWeb) {
      uri = Uri.https('www.google.com', '/maps/search/',
          {'api': '1', 'query': '$latitude,$longitude'});
    } else if (Platform.isAndroid) {
      var query = '$latitude,$longitude';

      if (label != null) query += '($label)';

      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
    } else if (Platform.isIOS) {
      var params = {
        'll': '$latitude,$longitude',
        'q': label ?? '$latitude, $longitude',
      };

      uri = Uri.https('maps.apple.com', '/', params);
    } else {
      uri = Uri.https('www.google.com', '/maps/search/',
          {'api': '1', 'query': '$latitude,$longitude'});
    }

    return _launchUrl(uri, url_launcher.LaunchMode.externalApplication);
  }

  static Future<bool> launchPdf(Uint8List data) async {
    File file = await _createTemporaryPDFFile(data);
    Logging.log(file.path);
    return _launchUrl(Uri.parse(file.path),
        url_launcher.LaunchMode.externalNonBrowserApplication);
  }

  static Future<File> _createTemporaryPDFFile(Uint8List pdfBytes) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/sample.pdf');
    await tempFile.writeAsBytes(pdfBytes, flush: true);
    return tempFile;
  }

  /// @returns true if the url was launched
  /// @param url is the url to be launched
  static Future<bool> launchUrl(String url) async {
    if (!url.startsWith('https') && !url.startsWith('http')) {
      url = 'https://$url';
    }
    Uri uri = Uri.parse(url);
    return await _launchUrl(uri);
  }

  static Future<bool> _launchUrl(Uri uri,
      [url_launcher.LaunchMode? mode]) async {
    try {
      if (await url_launcher.canLaunchUrl(uri)) {
        return await url_launcher.launchUrl(uri,
            mode: mode ?? url_launcher.LaunchMode.platformDefault);
      } else {
        Logging.logDetails('Cannot Launch Url', uri);
      }
    } catch (e) {
      Logging.logDetails('Error Launching', e);
    }
    return false;
  }
}
