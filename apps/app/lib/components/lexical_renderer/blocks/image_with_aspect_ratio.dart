import 'package:flutter/material.dart';
import 'package:news_blog/components/image.dart';
import 'package:news_blog/i18n/i18n.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ImageWithAspectRatioBlock extends StatelessWidget {
  final Map<String, dynamic> node;

  const ImageWithAspectRatioBlock({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    dynamic fields = node['fields'] ?? {};

    final String? imageUrl = fields['image']?['url'];

    final String? rawAspectRatio = fields['aspectRatio']?.toString();
    final List<int> aspectRatioParts =
        rawAspectRatio != null && rawAspectRatio.contains('/')
        ? rawAspectRatio
              .split('/')
              .map((part) => int.tryParse(part.trim()) ?? 1)
              .toList()
        : [16, 9];
    final int widthPart = aspectRatioParts.isNotEmpty
        ? aspectRatioParts[0]
        : 16;
    final int heightPart = aspectRatioParts.length > 1
        ? (aspectRatioParts[1] == 0 ? 1 : aspectRatioParts[1])
        : 9;
    double aspectRatio = widthPart / heightPart;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ImageWidget(
        url: imageUrl,
        containerBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              onError: (error, stackTrace) {
                Text(AppLocale.failedToLoadImage.getString(context));
              },
            ),
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
