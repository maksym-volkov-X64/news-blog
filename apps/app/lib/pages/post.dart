import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blog/components/layout.dart';
import 'package:news_blog/components/post.dart';
import 'package:news_blog/i18n/i18n.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.title, required this.postId});

  final String title;
  final String postId;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  void _goBack() {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    } else {
      GoRouter.of(context).go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        PostWidget(id: widget.postId),
        const SizedBox(height: 16.0),
      ],
    );

    return Layout(
      body: body,
      iosAppBar: CupertinoNavigationBar(
        middle: Text(
          '${AppLocale.appTitle.getString(context)} - ${widget.title.toUpperCase()}',
          overflow: TextOverflow.ellipsis,
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _goBack,
          child: const Icon(CupertinoIcons.chevron_back),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => GoRouter.of(context).push('/settings'),
          child: const Icon(CupertinoIcons.settings),
        ),
      ),
      androidAppBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          '${AppLocale.appTitle.getString(context)} - ${widget.title.toUpperCase()}',
        ),
        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back),
        ),
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
