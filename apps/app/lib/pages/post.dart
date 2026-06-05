import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blog/components/page.dart';

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
        title: Text('News Blog - ${widget.title.toUpperCase()}'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => GoRouter.of(context).go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
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
