import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blog/env/platform.dart';
import 'package:news_blog/i18n/i18n.dart';
import 'package:flutter_localization/flutter_localization.dart';

class Layout extends StatelessWidget {
  final Widget body;
  final ObstructingPreferredSizeWidget? iosAppBar;
  final PreferredSizeWidget? androidAppBar;

  const Layout({
    super.key,
    required this.body,
    this.iosAppBar,
    this.androidAppBar,
  });

  @override
  Widget build(BuildContext context) {
    void goBack() {
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
                onPressed: goBack,
                child: const Icon(CupertinoIcons.chevron_back),
              ),
            ),
        child: SafeArea(
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  body,
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
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
              onPressed: goBack,
              icon: const Icon(Icons.arrow_back),
            ),
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
          child: body,
        ),
      ),
    );
  }
}
