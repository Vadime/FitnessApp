import 'package:onboarding/models/onboarding_page_data.dart';

class OnboardingData {
  // singleton
  static final OnboardingData _instance = OnboardingData._();
  // makes sure that only one instance of OnboardingData exists
  factory OnboardingData() => _instance;
  // hides the constructor
  OnboardingData._();

  static List<OnboardingPageData> get data => _instance._data;

  late List<OnboardingPageData> _data;

  // from json factory
  static void fromJson(Map<String, dynamic> json) {
    _instance._data = (json['data'] as List<dynamic>).map((e) {
      return OnboardingPageData.fromJson(e);
    }).toList();
  }
}
