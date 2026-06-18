import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blog/components/layout.dart';
import 'package:news_blog/env/platform.dart';
import 'package:news_blog/i18n/i18n.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  void _goBack() {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    } else {
      GoRouter.of(context).go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        const SizedBox(height: 16.0),

        Row(
          children: [
            LanguageButton(
              selected: _localization.currentLocale?.languageCode == 'en',
              text: 'ENG',
              onPressed: () {
                _localization.translate('en');
              },
            ),
            const SizedBox(width: 16.0),
            const Text("/", style: TextStyle(fontSize: 18)),
            const SizedBox(width: 16.0),
            LanguageButton(
              selected: _localization.currentLocale?.languageCode == 'uk',
              text: 'UKR',
              onPressed: () {
                _localization.translate('uk');
              },
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        ItemWidget(
          title: AppLocale.currentLanguage.getString(context),
          content: _localization.getLanguageName(),
        ),
        ItemWidget(
          title: AppLocale.fontFamily.getString(context),
          content: _localization.fontFamily,
        ),
        ItemWidget(
          title: AppLocale.localeIdentifier.getString(context),
          content: _localization.currentLocale.localeIdentifier,
        ),
        const SizedBox(height: 16.0),
      ],
    );

    return Layout(
      body: content,
      iosAppBar: CupertinoNavigationBar(
        middle: Text(AppLocale.localization.getString(context)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _goBack,
          child: const Icon(CupertinoIcons.chevron_back),
        ),
      ),
      androidAppBar: AppBar(
        title: Text(AppLocale.localization.getString(context)),
        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.title, required this.content});

  final String? title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(title ?? '')),
          const Text(' : '),
          Expanded(child: Text(content ?? '')),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  const LanguageButton({
    super.key,
    required this.selected,
    required this.text,
    required this.onPressed,
  });

  final bool selected;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 2 - 36;

    if (isIOS) {
      return SizedBox(
        width: width,
        child: CupertinoButton(
          color: selected
              ? CupertinoColors.activeBlue
              : CupertinoColors.systemGrey4,
          padding: const EdgeInsets.symmetric(vertical: 10),
          onPressed: onPressed,
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: width,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
