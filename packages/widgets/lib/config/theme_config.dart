import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets/models/models.dart';

class ThemeConfig {
  final String title;
  final String logoLocation;
  final Color primaryColor;
  final Color neutralColor;
  final Color errorColor;

  final Color darkBackgroundColor;
  final Color darkCardColor;
  final Color darkTextColor;
  final Color lightBackgroundColor;
  final Color lightCardColor;
  final Color lightTextColor;

  late final double padding;
  final double borderWidth = 4;

  final double radius;
  final double opacity;

  ThemeConfig({
    required this.title,
    required this.logoLocation,
    required this.primaryColor,
    required this.neutralColor,
    required this.errorColor,
    required this.darkBackgroundColor,
    required this.darkCardColor,
    required this.darkTextColor,
    required this.lightBackgroundColor,
    required this.lightCardColor,
    required this.lightTextColor,
    required this.opacity,
    required this.radius,
    required this.padding,
  });

  static ScreenSize screenSize(BuildContext context) {
    const double small = 1200;
    const double medium = 1800;

    final shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide < small) return ScreenSize.small;
    if (shortestSide < medium) return ScreenSize.medium;
    return ScreenSize.large;
  }

  ThemeConfig.standard({
    this.title = 'Standard App',
    this.logoLocation = 'res/images/logo.png',
    this.primaryColor = Colors.blue,
    this.neutralColor = Colors.grey,
    this.errorColor = const Color(0xFFC62828),
    this.darkBackgroundColor = Colors.black,
    this.darkCardColor = Colors.black,
    this.darkTextColor = Colors.white,
    this.lightBackgroundColor = Colors.white,
    this.lightCardColor = Colors.white,
    this.lightTextColor = Colors.black,
    this.opacity = 0.8,
    this.radius = 10,
    this.padding = 20,
  });

  double get paddingD => padding * 2;
  double get paddingH => padding / 2;

  Color backgroundColor(Brightness brightness) => brightness == Brightness.light
      ? lightBackgroundColor
      : darkBackgroundColor;

  Color cardColor(Brightness brightness) =>
      brightness == Brightness.light ? lightCardColor : darkCardColor;

  Color textColor(Brightness brightness) =>
      brightness == Brightness.light ? lightTextColor : darkTextColor;

  // copyWith
  ThemeConfig copyWith({
    String? title,
    String? logoLocation,
    Brightness? brightness,
    Color? primaryColor,
    Color? neutralColor,
    Color? errorColor,
    Color? darkBackgroundColor,
    Color? darkCardColor,
    Color? darkTextColor,
    Color? lightBackgroundColor,
    Color? lightCardColor,
    Color? lightTextColor,
    double? padding,
    double? radius,
    double? opacity,
  }) =>
      ThemeConfig(
        title: title ?? this.title,
        logoLocation: logoLocation ?? this.logoLocation,
        primaryColor: primaryColor ?? this.primaryColor,
        neutralColor: neutralColor ?? this.neutralColor,
        errorColor: errorColor ?? this.errorColor,
        darkBackgroundColor: darkBackgroundColor ?? this.darkBackgroundColor,
        darkCardColor: darkCardColor ?? this.darkCardColor,
        darkTextColor: darkTextColor ?? this.darkTextColor,
        lightBackgroundColor: lightBackgroundColor ?? this.lightBackgroundColor,
        lightCardColor: lightCardColor ?? this.lightCardColor,
        lightTextColor: lightTextColor ?? this.lightTextColor,
        padding: padding ?? this.padding,
        radius: radius ?? this.radius,
        opacity: opacity ?? this.opacity,
      );

  // gen ThemeData
  ThemeData genTheme(Brightness brightness) {
    return ThemeData(
      canvasColor: backgroundColor(brightness),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      shadowColor: Colors.transparent,
      useMaterial3: true,
      // colors
      primaryColor: primaryColor,
      cardColor: cardColor(brightness),
      scaffoldBackgroundColor: backgroundColor(brightness),
      hintColor: neutralColor,
      dividerColor: neutralColor,
      indicatorColor: primaryColor,
      applyElevationOverlayColor: false,
      primaryColorDark: primaryColor,
      primaryColorLight: primaryColor,
      disabledColor: neutralColor,
      secondaryHeaderColor: primaryColor,
      dialogBackgroundColor: backgroundColor(brightness),
      unselectedWidgetColor: neutralColor,
      colorScheme:
          ColorScheme.fromSeed(seedColor: primaryColor, brightness: brightness),
      // text
      fontFamily: 'Varela Round',
      textTheme: TextTheme(
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          letterSpacing: 0,
          color: textColor(brightness).withOpacity(opacity),
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          letterSpacing: 0,
          color: textColor(brightness),
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          letterSpacing: 0,
          fontWeight: FontWeight.w600,
          color: textColor(brightness),
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          letterSpacing: 0,
          fontWeight: FontWeight.normal,
          color: textColor(brightness).withOpacity(opacity),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          letterSpacing: 0,
          fontWeight: FontWeight.normal,
          color: textColor(brightness),
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          letterSpacing: 0,
          fontWeight: FontWeight.bold,
          color: textColor(brightness),
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          letterSpacing: 0,
          fontWeight: FontWeight.normal,
          color: textColor(brightness).withOpacity(opacity),
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          letterSpacing: 0,
          fontWeight: FontWeight.normal,
          color: textColor(brightness),
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          letterSpacing: 0,
          fontWeight: FontWeight.w600,
          color: textColor(brightness),
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          letterSpacing: 0,
          fontWeight: FontWeight.w600,
          color: textColor(brightness).withOpacity(opacity),
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          letterSpacing: 0,
          fontWeight: FontWeight.normal,
          color: textColor(brightness),
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          letterSpacing: 0,
          fontWeight: FontWeight.w600,
          color: textColor(brightness),
        ),
      ),
      drawerTheme: DrawerThemeData(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          //scrimColor: Colors.transparent,
          backgroundColor: backgroundColor(brightness)),
      // input
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
      // card
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 0,
        color: cardColor(brightness),
        margin: EdgeInsets.zero,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: cardColor(brightness),
          borderRadius: BorderRadius.circular(radius),
        ),
        textStyle: TextStyle(
          color: textColor(brightness),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      // button
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: EdgeInsets.zero,
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        extendedPadding: EdgeInsets.zero,
      ),

      iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
              //padding: EdgeInsets.zero,
              //alignment: Alignment.center,
              //minimumSize: Size.zero,
              //tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //visualDensity: VisualDensity.compact,
              )),
      // elevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      // outlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          foregroundColor: primaryColor,
          padding: EdgeInsets.all(paddingH),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      // textButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          foregroundColor: primaryColor,
          elevation: 0,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      // slider
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: neutralColor,
        thumbColor: primaryColor,
        overlayColor: primaryColor.withOpacity(0.1),
        trackHeight: 2,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: radius,
        ),
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: radius,
        ),
      ),
      // progress
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        circularTrackColor: neutralColor,
        linearTrackColor: neutralColor,
      ),
      // divider
      dividerTheme: DividerThemeData(
        color: neutralColor,
        thickness: 1,
        space: 0,
      ),
      // dialog
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      // bottomSheet
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        backgroundColor: cardColor(brightness),
        elevation: 0,
        modalBackgroundColor: cardColor(brightness),
        modalElevation: 0,
      ),
      // popupMenu
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        color: cardColor(brightness),
        elevation: 0,
      ),
      // bottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardColor(brightness).withOpacity(opacity),
        elevation: 0,
        selectedItemColor: primaryColor,
        unselectedItemColor: neutralColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      // bottomAppBar
      bottomAppBarTheme: const BottomAppBarTheme(
        elevation: 0,
      ),
      // appBar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardColor(brightness).withOpacity(opacity),
        systemOverlayStyle: brightness == Brightness.light
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(
          color: textColor(brightness),
        ),
        actionsIconTheme: IconThemeData(
          color: textColor(brightness),
        ),
        titleTextStyle: TextStyle(
          color: textColor(brightness),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      // snackBar
      snackBarTheme: SnackBarThemeData(
        elevation: 0,
        contentTextStyle: TextStyle(
          color: textColor(brightness),
          fontSize: 14,
        ),
      ),

      // listtile
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        minLeadingWidth: 0,
        horizontalTitleGap: 0,
        minVerticalPadding: 0,
        tileColor: cardColor(brightness),
        iconColor: textColor(brightness),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
