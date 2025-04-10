import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryVariant,
    required this.onPrimary,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceBackground,
    required this.onSurface,
    required this.onSurfaceDim,
    required this.onSurfaceVariant,
    required this.surfaceBorder,
    required this.gradTop,
    required this.delete,
    required this.highlight,
    required this.unread,
    required this.star,
    required this.progressLow,
    required this.progressMedium,
    required this.progressComplete,
    required this.progressBackground,
    required this.roleParent,
    required this.roleTeacher,
    required this.grey,
    required this.greyDark,
    required this.secondary
  });

  final Color primary;
  final Color primaryVariant;
  final Color onPrimary;
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceBackground;
  final Color onSurface;
  final Color onSurfaceDim;
  final Color onSurfaceVariant;
  final Color surfaceBorder;
  final Color gradTop;
  final Color delete;
  final Color highlight;
  final Color unread;
  final Color star;
  final Color progressLow;
  final Color progressMedium;
  final Color progressComplete;
  final Color progressBackground;
  final Color roleParent;
  final Color roleTeacher;
  final Color grey;
  final Color greyDark;
  final Color secondary;

  @override
  ThemeExtension<AppColors> copyWith({
   Color? primary,
   Color? primaryVariant,
   Color? onPrimary,
   Color? surface,
   Color? surfaceVariant,
   Color? surfaceBackground,
   Color? onSurface,
   Color? onSurfaceDim,
   Color? onSurfaceVariant,
   Color? surfaceBorder,
   Color? gradTop,
   Color? delete,
   Color? highlight,
   Color? unread,
   Color? star,
   Color? progressLow,
   Color? progressMedium,
   Color? progressComplete,
   Color? progressBackground,
   Color? roleParent,
   Color? roleTeacher,
   Color? grey,
   Color? greyDark,
   Color? secondary
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      onPrimary: onPrimary ?? this.onPrimary,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceBackground: surfaceBackground ?? this.surfaceBackground,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceDim: onSurfaceDim ?? this.onSurfaceDim,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      surfaceBorder: surfaceBorder ?? this.surfaceBorder,
      gradTop: gradTop ?? this.gradTop,
      delete: delete ?? this.delete,
      highlight: highlight ?? this.highlight,
      unread: unread ?? this.unread,
      star: star ?? this.star,
      progressLow: progressLow ?? this.progressLow,
      progressMedium: progressMedium ?? this.progressMedium,
      progressComplete: progressComplete ?? this.progressComplete,
      progressBackground: progressBackground ?? this.progressBackground,
      roleParent: roleParent ?? this.roleParent,
      roleTeacher: roleTeacher ?? this.roleTeacher,
      grey: grey ?? this.grey,
      greyDark: greyDark ?? this.greyDark,
      secondary: secondary ?? this.secondary
    );
  }

  @override
  ThemeExtension<AppColors> lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t) ?? Colors.transparent,
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t) ?? Colors.transparent,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t) ?? Colors.transparent,
      surface: Color.lerp(surface, other.surface, t) ?? Colors.transparent,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t) ?? Colors.transparent,
      surfaceBackground: Color.lerp(surfaceBackground, other.surfaceBackground, t) ?? Colors.transparent,
      onSurface: Color.lerp(onSurface, other.onSurface, t) ?? Colors.transparent,
      onSurfaceDim: Color.lerp(onSurfaceDim, other.onSurfaceDim, t) ?? Colors.transparent,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t) ?? Colors.transparent,
      surfaceBorder: Color.lerp(surfaceBorder, other.surfaceBorder, t) ?? Colors.transparent,
      gradTop: Color.lerp(gradTop, other.gradTop, t) ?? Colors.transparent,
      delete: Color.lerp(delete, other.delete, t) ?? Colors.transparent,
      highlight: Color.lerp(highlight, other.highlight, t) ?? Colors.transparent,
      unread: Color.lerp(unread, other.unread, t) ?? Colors.transparent,
      star: Color.lerp(star, other.star, t) ?? Colors.transparent,
      progressLow: Color.lerp(progressLow, other.progressLow, t) ?? Colors.transparent,
      progressMedium: Color.lerp(progressMedium, other.progressMedium, t) ?? Colors.transparent,
      progressComplete: Color.lerp(progressComplete, other.progressComplete, t) ?? Colors.transparent,
      progressBackground: Color.lerp(progressBackground, other.progressBackground, t) ?? Colors.transparent,
      roleParent: Color.lerp(roleParent, other.roleParent, t) ?? Colors.transparent,
      roleTeacher: Color.lerp(roleTeacher, other.roleTeacher, t) ?? Colors.transparent,
      grey: Color.lerp(grey, other.grey, t) ?? Colors.transparent,
      greyDark: Color.lerp(greyDark, other.greyDark, t) ?? Colors.transparent,
      secondary: Color.lerp(secondary, other.secondary, t) ?? Colors.transparent,
    );
  }
}