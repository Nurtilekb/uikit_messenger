import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.scaffoldBackground,
    required this.surface,
    required this.cardBackground,
    required this.chatBackground,
    required this.inputBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textOnPrimary,
    required this.border,
    required this.divider,
    required this.online,
    required this.error,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.shadow,
    required this.tabBackground,
    required this.tabSelected,
    required this.tabUnselected,
    required this.profileHeader,
    required this.profileAvatarBackground,
    required this.settingsItemSelected,
    required this.settingsItemBorder,
    required this.messageBubbleOther,
    required this.messageTextOther,
    required this.messageTimeOther,
    required this.composerInputBackground,
    required this.buttonBackground,
    required this.googleButtonBackground,
    required this.googleButtonBorder,
    required this.googleButtonIcon,
  });

  // Primary
  final Color primary;
  final Color primaryDark;

  // Backgrounds
  final Color scaffoldBackground;
  final Color surface;
  final Color cardBackground;
  final Color chatBackground;
  final Color inputBackground;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color textOnPrimary;

  // Borders & Dividers
  final Color border;
  final Color divider;

  // Status
  final Color online;
  final Color error;

  // Icons
  final Color iconPrimary;
  final Color iconSecondary;

  // Shadows
  final Color shadow;

  // Auth
  final Color tabBackground;
  final Color tabSelected;
  final Color tabUnselected;

  // Profile
  final Color profileHeader;
  final Color profileAvatarBackground;

  // Settings
  final Color settingsItemSelected;
  final Color settingsItemBorder;

  // Chat
  final Color messageBubbleOther;
  final Color messageTextOther;
  final Color messageTimeOther;
  final Color composerInputBackground;

  // Buttons
  final Color buttonBackground;
  final Color googleButtonBackground;
  final Color googleButtonBorder;
  final Color googleButtonIcon;

  static const light = AppColors(
    primary: Color(0xff0A84FF),
    primaryDark: Color(0xFF0066FF),
    scaffoldBackground: Colors.white,
    surface: Color(0xFFF5F5F5),
    cardBackground: Colors.white,
    chatBackground: Color.fromARGB(17, 0, 0, 0),
    inputBackground: Color.fromARGB(17, 0, 0, 0),
    textPrimary: Color(0xDE000000),
    textSecondary: Color(0x99000000),
    textHint: Color(0x61000000),
    textOnPrimary: Colors.white,
    border: Color(0xFFE0E0E0),
    divider: Color.fromARGB(17, 0, 0, 0),
    online: Colors.green,
    error: Color(0xFFE53935),
    iconPrimary: Color(0x73000000),
    iconSecondary: Color(0x42000000),
    shadow: Color(0x0D000000),
    tabBackground: Color(0x2E9E9E9E),
    tabSelected: Colors.white,
    tabUnselected: Color(0x5F0A0A0A),
    profileHeader: Color(0xD9E3EFF9),
    profileAvatarBackground: Color(0xFFE0E7EA),
    settingsItemSelected: Colors.blue,
    settingsItemBorder: Color(0xFFE0E0E0),
    messageBubbleOther: Colors.white,
    messageTextOther: Color(0xDE000000),
    messageTimeOther: Color(0x9E9E9E9E),
    composerInputBackground: Color.fromARGB(17, 0, 0, 0),
    buttonBackground: Colors.white,
    googleButtonBackground: Colors.white,
    googleButtonBorder: Color(0xFFE0E0E0),
    googleButtonIcon: Color(0xFF616161),
  );

  static const dark = AppColors(
    primary: Color(0xff0A84FF),
    primaryDark: Color(0xFF0066FF),
    scaffoldBackground: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    cardBackground: Color(0xFF1E1E1E),
    chatBackground: Color(0xFF0A0A0A),
    inputBackground: Color(0xFF2C2C2C),
    textPrimary: Color(0xE6FFFFFF),
    textSecondary: Color(0x99FFFFFF),
    textHint: Color(0x61FFFFFF),
    textOnPrimary: Colors.white,
    border: Color(0xFF333333),
    divider: Color(0x1AFFFFFF),
    online: Colors.green,
    error: Color(0xFFEF5350),
    iconPrimary: Color(0x73FFFFFF),
    iconSecondary: Color(0x42FFFFFF),
    shadow: Color(0x33000000),
    tabBackground: Color(0x2E616161),
    tabSelected: Color(0xFF2C2C2C),
    tabUnselected: Color(0x5FFFFFFF),
    profileHeader: Color(0xFF1A2332),
    profileAvatarBackground: Color(0xFF2C3E50),
    settingsItemSelected: Colors.blue,
    settingsItemBorder: Color(0xFF333333),
    messageBubbleOther: Color(0xFF1E1E1E),
    messageTextOther: Color(0xE6FFFFFF),
    messageTimeOther: Color(0x61FFFFFF),
    composerInputBackground: Color(0xFF2C2C2C),
    buttonBackground: Color(0xFF1E1E1E),
    googleButtonBackground: Color(0xFF2C2C2C),
    googleButtonBorder: Color(0xFF333333),
    googleButtonIcon: Color(0xFFBDBDBD),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryDark,
    Color? scaffoldBackground,
    Color? surface,
    Color? cardBackground,
    Color? chatBackground,
    Color? inputBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? textOnPrimary,
    Color? border,
    Color? divider,
    Color? online,
    Color? error,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? shadow,
    Color? tabBackground,
    Color? tabSelected,
    Color? tabUnselected,
    Color? profileHeader,
    Color? profileAvatarBackground,
    Color? settingsItemSelected,
    Color? settingsItemBorder,
    Color? messageBubbleOther,
    Color? messageTextOther,
    Color? messageTimeOther,
    Color? composerInputBackground,
    Color? buttonBackground,
    Color? googleButtonBackground,
    Color? googleButtonBorder,
    Color? googleButtonIcon,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      surface: surface ?? this.surface,
      cardBackground: cardBackground ?? this.cardBackground,
      chatBackground: chatBackground ?? this.chatBackground,
      inputBackground: inputBackground ?? this.inputBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      online: online ?? this.online,
      error: error ?? this.error,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      shadow: shadow ?? this.shadow,
      tabBackground: tabBackground ?? this.tabBackground,
      tabSelected: tabSelected ?? this.tabSelected,
      tabUnselected: tabUnselected ?? this.tabUnselected,
      profileHeader: profileHeader ?? this.profileHeader,
      profileAvatarBackground: profileAvatarBackground ?? this.profileAvatarBackground,
      settingsItemSelected: settingsItemSelected ?? this.settingsItemSelected,
      settingsItemBorder: settingsItemBorder ?? this.settingsItemBorder,
      messageBubbleOther: messageBubbleOther ?? this.messageBubbleOther,
      messageTextOther: messageTextOther ?? this.messageTextOther,
      messageTimeOther: messageTimeOther ?? this.messageTimeOther,
      composerInputBackground: composerInputBackground ?? this.composerInputBackground,
      buttonBackground: buttonBackground ?? this.buttonBackground,
      googleButtonBackground: googleButtonBackground ?? this.googleButtonBackground,
      googleButtonBorder: googleButtonBorder ?? this.googleButtonBorder,
      googleButtonIcon: googleButtonIcon ?? this.googleButtonIcon,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      scaffoldBackground: Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      chatBackground: Color.lerp(chatBackground, other.chatBackground, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      online: Color.lerp(online, other.online, t)!,
      error: Color.lerp(error, other.error, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      tabBackground: Color.lerp(tabBackground, other.tabBackground, t)!,
      tabSelected: Color.lerp(tabSelected, other.tabSelected, t)!,
      tabUnselected: Color.lerp(tabUnselected, other.tabUnselected, t)!,
      profileHeader: Color.lerp(profileHeader, other.profileHeader, t)!,
      profileAvatarBackground: Color.lerp(profileAvatarBackground, other.profileAvatarBackground, t)!,
      settingsItemSelected: Color.lerp(settingsItemSelected, other.settingsItemSelected, t)!,
      settingsItemBorder: Color.lerp(settingsItemBorder, other.settingsItemBorder, t)!,
      messageBubbleOther: Color.lerp(messageBubbleOther, other.messageBubbleOther, t)!,
      messageTextOther: Color.lerp(messageTextOther, other.messageTextOther, t)!,
      messageTimeOther: Color.lerp(messageTimeOther, other.messageTimeOther, t)!,
      composerInputBackground: Color.lerp(composerInputBackground, other.composerInputBackground, t)!,
      buttonBackground: Color.lerp(buttonBackground, other.buttonBackground, t)!,
      googleButtonBackground: Color.lerp(googleButtonBackground, other.googleButtonBackground, t)!,
      googleButtonBorder: Color.lerp(googleButtonBorder, other.googleButtonBorder, t)!,
      googleButtonIcon: Color.lerp(googleButtonIcon, other.googleButtonIcon, t)!,
    );
  }
}

extension AppColorsExtension on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
