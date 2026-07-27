import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uikit/widgets/profile_widgets/build_lang_item.dart';

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

  final List<Map<String, String>> languages = [
    {'flag': '🇺🇸', 'name': 'English', 'code': 'en'},
    {'flag': '🇷🇺', 'name': 'Русский', 'code': 'ru'},
    {'flag': '🇰🇬', 'name': 'Кыргызча', 'code': 'ky'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selected_language');
    if (savedLanguage != null) {
      setState(() {
        selectedLanguage = savedLanguage;
      });
    }
  }

  Future<void> _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
  }

  String getLanguageName(String language) {
    return language
        .replaceFirst('🇺🇸 ', '')
        .replaceFirst('🇷🇺 ', '')
        .replaceFirst('🇰🇬 ', '');
  }

  String getLanguageCode(String language) {
    for (var lang in languages) {
      if (language.contains(lang['name']!)) {
        return lang['code']!;
      }
    }
    return 'ru';
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
                                      BuiltLangItem(
                                        key: ValueKey(lang['code']),
                                        text: '${lang['flag']} ${lang['name']}',
                                        currentSelected: selectedLanguage,
                                        colors: colors,
                                        onTap: () async {
                                          final newLanguage =
                                              '${lang['flag']} ${lang['name']}';

                                          await context.setLocale(
                                            Locale(lang['code']!),
                                          );
                                          await _saveLanguage(newLanguage);

                                          setState(() {
                                            selectedLanguage = newLanguage;
                                          });

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
                          Text(
                            'language'.tr(),
                            style: TextStyle(
                              fontSize: 18,
                              color: colors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            getLanguageName(selectedLanguage),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            CupertinoIcons.forward,
                            color: colors.iconSecondary,
                          ),
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
                          'darktheme'.tr(),
                          style: TextStyle(
                            fontSize: 18,
                            color: colors.textPrimary,
                          ),
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
}
