import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String? url;
  final String placeholderImagePath;
  final String errorImagePath;

  final Widget Function(BuildContext context, ImageProvider imageProvider)
  containerBuilder;
  final Widget? Function(BuildContext context, ImageProvider imageProvider)?
  errorContainerBuilder;

  const ImageWidget({
    super.key,
    this.url,
    this.placeholderImagePath = 'assets/images/placeholder.png',
    this.errorImagePath = 'assets/images/placeholder.png',
    required this.containerBuilder,
    this.errorContainerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider placeholderImageProvider = Image.asset(
      placeholderImagePath,
    ).image;

    final ImageProvider errorImageProvider = Image.asset(errorImagePath).image;

    return url == null
        ? Container(child: containerBuilder(context, errorImageProvider))
        : CachedNetworkImage(
            imageUrl: url!,
            placeholder: (context, url) =>
                containerBuilder(context, placeholderImageProvider),
            errorWidget: (context, url, error) =>
                errorContainerBuilder?.call(context, errorImageProvider) ??
                containerBuilder(context, errorImageProvider),
            imageBuilder: (context, imageProvider) =>
                containerBuilder(context, imageProvider),
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            placeholderFadeInDuration: Duration.zero,
          );
  }
}
