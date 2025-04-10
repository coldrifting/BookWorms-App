import 'package:bookworms_app/resources/app_colors.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:flutter/material.dart';

// App Colors
const _colorBlack = Colors.black;
const _colorGreyDark = Color(0xff616161);
const _colorGrey = Colors.grey;
const _colorGreyLight = Color(0xFFEEEEEE);
const _colorWhite = Colors.white;
const _colorYellow = Colors.amber;
const _colorRed = Color(0xFFD32F2F);
const _colorGreenDark = Color(0xff1B5E20);
const _colorGreen = Color(0xff2E7D32);
const _colorGreenGradTop = Color(0xFF80BC81);
const _colorGreenLight = Color(0xffc1e8c1);

const _teacherRoleColor = Color(0xffe63961);
const _parentRoleColor = Color(0xff308860);

// Button Themes
var welcomeTextButtonStyle = TextButton.styleFrom(foregroundColor: _colorWhite);
var welcomeElevatedButtonStyle = TextButton.styleFrom(foregroundColor: _colorGreenDark, backgroundColor: _colorWhite);

buttonStyle(BuildContext context, Color? backgroundColor, Color? foregroundColor, {double radius = 15}) =>
    ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? context.colors.surface,
        foregroundColor: foregroundColor ?? context.colors.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius))
    );

profileButtonStyle(BuildContext context) => TextButton.styleFrom(
    backgroundColor: context.colors.surfaceVariant,
    foregroundColor: context.colors.onSurface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    side: BorderSide(color: context.colors.surfaceBorder),
    padding: EdgeInsets.all(16.0));

var smallButtonStyle = TextButton.styleFrom(
    backgroundColor: _colorGreen,
    foregroundColor: _colorWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ));

var mediumButtonStyle = ElevatedButton.styleFrom(
    minimumSize: Size(200, 38),
    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    iconSize: 26,
    foregroundColor: _colorWhite,
    backgroundColor: _colorGreen);

var largeButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: _colorWhite,
  backgroundColor: _colorGreen,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
  ),
  textStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
  minimumSize: Size(double.infinity, 64),
);

ButtonStyle getCommonButtonStyle({Color primaryColor = _colorGreen, Color? secondaryColor = _colorWhite, bool isElevated = true}) {
  return ElevatedButton.styleFrom(
          backgroundColor: isElevated ? primaryColor : Colors.transparent,
          foregroundColor: isElevated ? secondaryColor : primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
}

// Text styles
errorTextStyle(BuildContext context) => TextStyle(color: Theme.of(context).colorScheme.error);

// Custom Pallet Themes
var lightAppColors = AppColors(
    primary: _colorGreen,
    primaryVariant: _colorGreenDark,
    onPrimary: _colorWhite,
    surface: _colorWhite,
    surfaceVariant: _colorGreyLight,
    surfaceBackground: Color(0xfff7fbf1),
    onSurface: _colorBlack,
    onSurfaceDim: _colorGrey,
    onSurfaceVariant: _colorGreyDark,
    surfaceBorder: _colorGreyDark,
    gradTop: _colorGreenGradTop,
    delete: _colorRed,
    highlight: _colorGreen,
    unread: _colorRed,
    star: _colorYellow,
    progressLow: _colorRed,
    progressMedium: _colorYellow,
    progressComplete: _colorGreen,
    progressBackground: Colors.grey[350]!,
    roleParent: _parentRoleColor,
    roleTeacher: _teacherRoleColor,
    grey: Colors.grey[800]!,
    greyDark: _colorGreyDark,
    secondary: _colorGreenLight
);

var darkAppColors = AppColors(
    primary: _colorGreen,
    primaryVariant: _colorGreenDark,
    onPrimary: _colorWhite,
    surface: Color(0xff121510),
    surfaceVariant: Color(0xFF191919),
    surfaceBackground: Color(0xff121510),
    onSurface: _colorWhite,
    onSurfaceDim: _colorGrey,
    onSurfaceVariant: _colorGreyDark,
    surfaceBorder: Color(0xFF333333),
    gradTop: _colorGreenGradTop,
    delete: _colorRed,
    highlight: _colorGreen,
    unread: _colorRed,
    star: _colorYellow,
    progressLow: _colorRed,
    progressMedium: _colorYellow,
    progressComplete: _colorGreen,
    progressBackground: Color(0xFF333333),
    roleParent: _parentRoleColor,
    roleTeacher: _teacherRoleColor,
    grey: Colors.grey[200]!,
    greyDark: _colorGreyDark,
    secondary: Color(0xff315133)
);

// Helper for bookshelf theming
getBookshelfColor(BuildContext context, BookshelfType type, {bool isForeground = false}) {
  bool lightMode = Theme.of(context).brightness == Brightness.light;
  if (lightMode) {
    return isForeground
        ? type.color[700]
        : type.color[200];
  }
  return isForeground
      ? type.color[200]!.withValues(alpha: 0.5)
      : type.color[700]!.withValues(alpha: 0.75);
}

// Overall Light and Dark Mode Themes
final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme
      .fromSeed(seedColor: _colorGreen)
      .copyWith(
        primary: _colorGreen,
        onPrimary: _colorWhite,
        primaryContainer: _colorGreenDark,
        secondary: _colorRed,
      ),
  useMaterial3: true,
  fontFamily: "Montserrat",
  brightness: Brightness.light,
  textTheme: textTheme
);

final ThemeData appThemeDark = ThemeData(
  colorScheme: ColorScheme
      .fromSeed(seedColor: _colorGreen, brightness: Brightness.dark)
      .copyWith(
        primary: _colorGreen,
        onPrimary: _colorWhite,
        primaryContainer: _colorGreenGradTop,
        secondary: _colorRed,
      ),
  useMaterial3: true,
  fontFamily: "Montserrat",
  brightness: Brightness.dark,
  textTheme: textTheme
);

final TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 57),
    displayMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
    displaySmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
    headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
    headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
    headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    bodySmall: TextStyle(fontSize: 12),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
);

extension WhiteTextTheme on TextTheme {
  TextStyle get displaySmallWhite => displaySmall!.copyWith(color: _colorWhite);
  TextStyle get headlineLargeWhite => headlineLarge!.copyWith(color: _colorWhite);
  TextStyle get headlineMediumGreenDark => headlineMedium!.copyWith(color: _colorGreenDark);
  TextStyle get headlineMediumWhite => headlineMedium!.copyWith(color: _colorWhite);
  TextStyle get headlineSmallWhite => headlineSmall!.copyWith(color: _colorWhite);
  TextStyle get titleLargeWhite => titleLarge!.copyWith(color: _colorWhite);
  TextStyle get titleMediumWhite => titleMedium!.copyWith(color: _colorWhite);
  TextStyle get titleSmallWhite => titleSmall!.copyWith(color: _colorWhite);
  TextStyle get bodyLargeWhite => bodyLarge!.copyWith(color: _colorWhite);
  TextStyle get bodyMediumWhite => bodyMedium!.copyWith(color: _colorWhite);
  TextStyle get bodySmallWhite => bodySmall!.copyWith(color: _colorWhite);
  TextStyle get labelLargeWhite => labelLarge!.copyWith(color: _colorWhite);
  TextStyle get labelMediumWhite => labelMedium!.copyWith(color: _colorWhite);
}

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  AppColors get colors => theme.extension<AppColors>() ?? lightAppColors;
}

// Gradient used in startup screens
BoxDecoration splashGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment(0.8, 1),
      colors: <Color>[
        _colorGreenGradTop,
        _colorGreenDark,
      ],
    ),
  );
}

// Custom Card style
class CardCustom extends StatelessWidget {
  const CardCustom({required this.child, this.padding = 0.0, super.key});

  final double padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: _colorGreyDark.withAlpha(64),
            spreadRadius: 2,
            blurRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}