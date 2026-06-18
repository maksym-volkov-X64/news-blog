import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blog/components/layout.dart';
import 'package:news_blog/components/posts.dart';
import 'package:news_blog/i18n/i18n.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),

          Text(
            AppLocale.pages.getString(context),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          PostsWidget(),

          const SizedBox(height: 16.0),
        ],
      ),
    );

    return Layout(
      body: content,
      iosAppBar: CupertinoNavigationBar(
        middle: Text(AppLocale.appTitle.getString(context)),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => GoRouter.of(context).push('/settings'),
          child: const Icon(CupertinoIcons.settings),
        ),
      ),
      androidAppBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocale.appTitle.getString(context)),
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).push('/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
