import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blog/env/platform.dart';
import 'package:news_blog/i18n/i18n.dart';
import 'package:flutter_localization/flutter_localization.dart';

Widget layout({
  required BuildContext context,
  required Widget body,
  ObstructingPreferredSizeWidget? iosAppBar,
  PreferredSizeWidget? androidAppBar,
}) {
  void _goBack() {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    } else {
      GoRouter.of(context).go('/');
    }
  }

  if (isIOS) {
    return CupertinoPageScaffold(
      navigationBar:
          iosAppBar ??
          CupertinoNavigationBar(
            middle: Text(AppLocale.appTitle.getString(context)),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _goBack,
              child: const Icon(CupertinoIcons.chevron_back),
            ),
          ),
      child: SafeArea(
        child: Material(
          type: MaterialType.transparency,
          child: Padding(padding: const EdgeInsets.all(16.0), child: body),
        ),
      ),
    );
  }

  return Scaffold(
    appBar:
        androidAppBar ??
        AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocale.appTitle.getString(context)),
          leading: IconButton(
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
    body: Padding(padding: const EdgeInsets.all(16.0), child: body),
  );
}
