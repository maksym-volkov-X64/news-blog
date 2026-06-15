import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blog/env/platform.dart';
import 'package:news_blog/get_data/payload.dart';
import 'package:news_blog/i18n/i18n.dart';
import 'package:news_blog/models/payload.dart';

FutureBuilder postsWidget() {
  return FutureBuilder(
    future: PayloadClient().getPosts(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              AppLocale.failedToLoadPosts.getString(context),
              style: const TextStyle(fontSize: 18),
            ),
          );
        }

        final List<PostModel> posts = snapshot.data!;
        return ListView.separated(
          itemBuilder: (context, index) {
            final post = posts[index];
            return _postItem(post: post, context: context);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemCount: posts.length,
        );
      } else {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
    },
  );
}

Widget _postItem({required PostModel post, required BuildContext context}) {
  MediaModel media = MediaModel.fromJson(post.media);

  void onTap() {
    GoRouter.of(context).pushNamed(
      'post',
      pathParameters: {'id': post.id.toString(), 'title': post.title},
    );
  }

  final content = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: NetworkImage(
                media.url ?? 'https://via.placeholder.com/150',
              ),
              fit: BoxFit.cover,
            ),
            color: Colors.white,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withAlpha(70),
                  Colors.black.withAlpha(30),
                  Colors.transparent.withAlpha(0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.3, 0.6, 1],
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              post.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );

  if (isIOS) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: content,
    );
  }

  return MaterialButton(onPressed: onTap, child: content);
}
