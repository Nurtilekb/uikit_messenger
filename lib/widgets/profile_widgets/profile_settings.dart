import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class ProfileSettings extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const ProfileSettings({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String selectedLanguage = '🇷🇺 Русский';

  final List<String> languages = [
    '🇺🇸 English',
    '🇷🇺 Русский',
    '🇰🇬 Кыргызча',
  ];

  void onSelectLang(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      child: Container(
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(25),
        ),
        height: 155,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setStateBottomSheet) {
                            return SafeArea(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    for (var lang in languages)
                                      _buildLanguageItem(
                                        lang,
                                        selectedLanguage,
                                        colors,
                                        () {
                                          setState(() {
                                            selectedLanguage = lang;
                                          });
                                          setStateBottomSheet(() {});
                                          Navigator.pop(context);
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 19, 8),
                    child: Center(
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: theme.dividerColor,
                            ),
                            height: 40,
                            width: 40,
                            child: const Icon(Icons.public_rounded),
                          ),
                          Text('Язык', style: TextStyle(fontSize: 18, color: colors.textPrimary)),
                          const Spacer(),
                          Text(
                            selectedLanguage
                                .replaceFirst('🇺🇸 ', '')
                                .replaceFirst('🇷🇺 ', '')
                                .replaceFirst('🇰🇬 ', ''),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(CupertinoIcons.forward, color: colors.iconSecondary),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 2,
              color: colors.border,
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 19, 8),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: theme.dividerColor,
                          ),
                          height: 40,
                          width: 40,
                          child: const Icon(Icons.dark_mode_outlined),
                        ),
                        Text(
                          'Тёмная тема',
                          style: TextStyle(fontSize: 18, color: colors.textPrimary),
                        ),
                        const Spacer(),
                        CupertinoSwitch(
                          activeTrackColor: theme.primaryColor,
                          value: widget.isDarkMode,
                          onChanged: widget.onDarkModeChanged,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(
    String text,
    String currentSelected,
    AppColors colors,
    VoidCallback onTap,
  ) {
    bool isSelected = currentSelected == text;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.settingsItemSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colors.settingsItemSelected : colors.settingsItemBorder,
          ),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(color: isSelected ? colors.textOnPrimary : colors.textPrimary),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check, color: colors.textOnPrimary, size: 18),
          ],
        ),
      ),
    );
  }
}
