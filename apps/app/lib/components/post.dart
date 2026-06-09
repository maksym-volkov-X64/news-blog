import 'package:news_blog/components/lexical_renderer/lexical_renderer.dart';
import 'package:news_blog/get_data/payload.dart';
import 'package:news_blog/models/payload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:news_blog/i18n/i18n.dart';

FutureBuilder postWidget(String? id) {
  return FutureBuilder(
    future: PayloadClient().getPost(id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError || snapshot.data == null) {
          return Center(
            child: Text(
              AppLocale.failedToLoadPost.getString(context),
              style: const TextStyle(fontSize: 18),
            ),
          );
        }

        final PostModel post = snapshot.data!;
        MediaModel media = MediaModel.fromJson(post.media);

        return Column(
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
              ),
            ),

            SizedBox(height: 10),

            Text(
              post.title.toUpperCase(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            LexicalRichText(json: post.content),

            SizedBox(height: 30),
          ],
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}
