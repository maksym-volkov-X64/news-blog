import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blog/get_data/payload.dart';
import 'package:news_blog/models/payload.dart';

final dio = Dio();

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
        title: Text('News Blog ${widget.title}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Page ${widget.postId}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              _page(widget.postId),
              ButtonTheme(
                child: ElevatedButton(
                  onPressed: () => GoRouter.of(context).go('/'),
                  child: const Text('Back to home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

FutureBuilder _page(String? id) {
  return FutureBuilder(
    future: PayloadClient().getPage(id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('Failed to load page'));
        }

        final PageModel page = snapshot.data!;
        MediaModel media = MediaModel.fromJson(page.media);

        return Column(
          children: [
            Image(image: NetworkImage(media.url ?? ''), fit: BoxFit.cover),
            Text(page.title),
          ],
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}
