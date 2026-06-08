import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blog/components/page.dart';
import 'package:news_blog/i18n/i18n.dart';
import 'package:flutter_localization/flutter_localization.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.title, required this.postId});

  final String title;
  final String postId;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          '${AppLocale.appTitle.getString(context)} - ${widget.title.toUpperCase()}',
        ),
        title: Text('News Blog - ${widget.title.toUpperCase()}'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => GoRouter.of(context).go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).push('/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [page(widget.postId)],
          ),
        ),
      ),
    );
  }
}
