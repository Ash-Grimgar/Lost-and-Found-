import 'package:flutter/material.dart';

CustomColors lightCustomColors = const CustomColors(
  borderColorNotOpened: Color(0xFFC2410C),
  borderColorOpened: Color(0xFFD7CCC8),
  claimAcceptedStatusColor: Color(0xFF15803D),
  claimWaitingStatusColor: Color(0xFFD97706),
  claimDeniedStatusColor: Color(0xFFB91C1C),
  nClaimsColor: Color(0xFFD97706),
  notOpenedColor: Color.fromRGBO(194, 65, 12, 0.15),
  openedColor: Color(0xFFF5EFEB),
  splashGreenColor: Color(0xFFC2410C),
  splashGreyColor: Color(0xFF78716C),
  secondaryTextColor: Color(0xFF78716C),
  background2: Color(0xFFFAF9F6),
  successSnackbar: Color(0xFF15803D),
);

CustomColors darkCustomColors = const CustomColors(
  borderColorNotOpened: Color(0xFFFB923C),
  borderColorOpened: Color(0xFF57534E),
  claimAcceptedStatusColor: Color(0xFF22C55E),
  claimWaitingStatusColor: Color(0xFFF59E0B),
  claimDeniedStatusColor: Color(0xFFEF4444),
  nClaimsColor: Color(0xFFF59E0B),
  notOpenedColor: Color.fromRGBO(251, 146, 60, 0.2),
  openedColor: Color(0xFF292524),
  splashGreenColor: Color(0xFFFB923C),
  splashGreyColor: Color(0xFFA8A29E),
  secondaryTextColor: Color(0xFFD6D3D1),
  background2: Color(0xFF1C1917),
  successSnackbar: Color(0xFF22C55E),
);

/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? nClaimsColor;
  final Color? claimWaitingStatusColor;
  final Color? claimAcceptedStatusColor;
  final Color? claimDeniedStatusColor;
  final Color? splashGreyColor;
  final Color? splashGreenColor;
  final Color? notOpenedColor;
  final Color? openedColor;
  final Color? borderColorOpened;
  final Color? secondaryTextColor;
  final Color? borderColorNotOpened;
  final Color? background2;
  final Color? successSnackbar;

  const CustomColors(
      {required this.nClaimsColor,
      required this.claimWaitingStatusColor,
      required this.claimAcceptedStatusColor,
      required this.claimDeniedStatusColor,
      required this.splashGreyColor,
      required this.splashGreenColor,
      required this.notOpenedColor,
      required this.openedColor,
      required this.borderColorOpened,
      required this.secondaryTextColor,
      required this.borderColorNotOpened,
      required this.background2,
      required this.successSnackbar});

  @override
  CustomColors copyWith(
      {Color? nClaimsColor,
      Color? claimWaitingStatusColor,
      Color? claimAcceptedStatusColor,
      Color? claimDeniedStatusColor,
      Color? splashGreyColor,
      Color? splashGreenColor,
      Color? notOpenedColor,
      Color? openedColor,
      Color? borderColorOpened,
      Color? secondaryTextColor,
      Color? borderColorNotOpened,
      Color? buttonPressed,
      Color? statusBarDefaultColor,
      Color? background2,
      Color? successSnackbar}) {
    return CustomColors(
      nClaimsColor: nClaimsColor ?? this.nClaimsColor,
      claimWaitingStatusColor: claimWaitingStatusColor ?? this.claimWaitingStatusColor,
      claimAcceptedStatusColor: claimAcceptedStatusColor ?? this.claimAcceptedStatusColor,
      claimDeniedStatusColor: claimDeniedStatusColor ?? this.claimDeniedStatusColor,
      splashGreyColor: splashGreyColor ?? this.splashGreyColor,
      splashGreenColor: splashGreenColor ?? this.splashGreenColor,
      notOpenedColor: notOpenedColor ?? this.notOpenedColor,
      openedColor: openedColor ?? this.openedColor,
      borderColorOpened: borderColorOpened ?? this.borderColorOpened,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      borderColorNotOpened: borderColorNotOpened ?? this.borderColorNotOpened,
      background2: background2 ?? this.background2,
      successSnackbar: successSnackbar ?? this.successSnackbar,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      nClaimsColor: Color.lerp(nClaimsColor, other.nClaimsColor, t),
      claimWaitingStatusColor: Color.lerp(claimWaitingStatusColor, other.claimWaitingStatusColor, t),
      claimAcceptedStatusColor: Color.lerp(claimAcceptedStatusColor, other.claimAcceptedStatusColor, t),
      claimDeniedStatusColor: Color.lerp(claimDeniedStatusColor, other.claimDeniedStatusColor, t),
      splashGreyColor: Color.lerp(splashGreyColor, other.splashGreyColor, t),
      splashGreenColor: Color.lerp(splashGreenColor, other.splashGreenColor, t),
      notOpenedColor: Color.lerp(notOpenedColor, other.notOpenedColor, t),
      openedColor: Color.lerp(openedColor, other.openedColor, t),
      borderColorOpened: Color.lerp(borderColorOpened, other.borderColorOpened, t),
      secondaryTextColor: Color.lerp(secondaryTextColor, other.secondaryTextColor, t),
      borderColorNotOpened: Color.lerp(borderColorNotOpened, other.borderColorNotOpened, t),
      background2: Color.lerp(background2, other.background2, t),
      successSnackbar: Color.lerp(successSnackbar, other.successSnackbar, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith();
  }
}
