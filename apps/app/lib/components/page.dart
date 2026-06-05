import 'package:news_blog/get_data/payload.dart';
import 'package:news_blog/models/payload.dart';
import 'package:flutter/material.dart';

FutureBuilder page(String? id) {
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
            // Image(image: NetworkImage(media.url ?? ''), fit: BoxFit.cover),
            Text(
              page.title.toUpperCase(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}
