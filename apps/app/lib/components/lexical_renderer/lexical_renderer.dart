import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:news_blog/components/lexical_renderer/blocks/image_with_aspect_ratio.dart';
import 'package:news_blog/components/lexical_renderer/link.dart';
import 'package:news_blog/i18n/i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class LexicalRichText extends StatelessWidget {
  final Map<String, dynamic> json;

  const LexicalRichText({super.key, required this.json});

  @override
  Widget build(BuildContext context) {
    final root = json['root'];
    if (root == null || root['children'] == null) {
      return const SizedBox.shrink();
    }

    final children = List<Map<String, dynamic>>.from(root['children']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((node) => _buildBlockNode(node, context)).toList(),
    );
  }

  Widget _buildBlockNode(Map<String, dynamic> node, BuildContext context) {
    final type = node['type'];

    switch (type) {
      case 'paragraph':
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _buildRichText(node, _getTextAlign(node['format']), context),
        );
      case 'heading':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _buildRichText(
            node,
            _getTextAlign(node['format']),
            context,
            baseStyle: _getHeadingStyle(node['tag']),
          ),
        );
      case 'list':
        return _buildList(node, context);
      case 'horizontalrule':
        return const Divider(height: 24.0, thickness: 1.0);
      case 'upload':
        return _buildUpload(node);
      case 'block':
        String? blockType = node['fields']?['blockType'];

        switch (blockType) {
          case 'image-with-aspect-ratio':
            return buildImageWithAspectRatioBlock(context, node);
          default:
            return const SizedBox.shrink();
        }
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildList(Map<String, dynamic> node, BuildContext context) {
    final listType = node['listType'];
    final children = List<Map<String, dynamic>>.from(node['children'] ?? []);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.map((item) {
          final itemChildren = List<Map<String, dynamic>>.from(
            item['children'] ?? [],
          );

          Widget marker;
          if (listType == 'bullet') {
            marker = const Text('• ', style: TextStyle(fontSize: 16));
          } else if (listType == 'number') {
            marker = Text(
              '${item['value'] ?? ''}. ',
              style: const TextStyle(fontSize: 16),
            );
          } else if (listType == 'check') {
            marker = Checkbox(
              value: item['checked'] ?? false,
              onChanged: null, // Read-only
              visualDensity: VisualDensity.compact,
            );
          } else {
            marker = const Text('- ');
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (listType != 'check')
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, right: 8.0),
                  child: marker,
                )
              else
                marker,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: listType == 'check' ? 8.0 : 2.0,
                  ),
                  child: TextSpanBuilder(
                    children: itemChildren,
                    context: context,
                  ).build(),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUpload(Map<String, dynamic> node) {
    final value = node['value'];
    if (value == null || value['url'] == null) return const SizedBox.shrink();

    final url = (value['url'] as String);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Image.network(
        url,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Text(AppLocale.failedToLoadImage.getString(context)),
      ),
    );
  }

  Widget _buildRichText(
    Map<String, dynamic> node,
    TextAlign align,
    BuildContext context, {
    TextStyle? baseStyle,
  }) {
    final children = List<Map<String, dynamic>>.from(node['children'] ?? []);
    return SizedBox(
      width: double.infinity,
      child: TextSpanBuilder(
        children: children,
        context: context,
        baseStyle: baseStyle,
        textAlign: align,
      ).build(),
    );
  }

  TextAlign _getTextAlign(dynamic format) {
    if (format == 'center') return TextAlign.center;
    if (format == 'right') return TextAlign.right;
    if (format == 'justify') return TextAlign.justify;
    return TextAlign.left;
  }

  TextStyle _getHeadingStyle(String? tag) {
    switch (tag) {
      case 'h1':
        return const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );
      case 'h2':
        return const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );
      case 'h3':
        return const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );
      case 'h4':
        return const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );
      case 'h5':
        return const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );
      case 'h6':
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );
      default:
        return const TextStyle(fontSize: 16);
    }
  }
}

class TextSpanBuilder {
  final List<Map<String, dynamic>> children;
  final TextStyle? baseStyle;
  final TextAlign textAlign;
  final BuildContext context;

  TextSpanBuilder({
    required this.children,
    required this.context,
    this.baseStyle,
    this.textAlign = TextAlign.left,
  });

  Widget build() {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: baseStyle ?? const TextStyle(color: Colors.black, fontSize: 16),
        children: children.map((child) => _buildSpan(child)).toList(),
      ),
    );
  }

  InlineSpan _buildSpan(Map<String, dynamic> node) {
    final type = node['type'];

    if (type == 'link') {
      final linkChildren = List<Map<String, dynamic>>.from(
        node['children'] ?? [],
      );
      final String linkType = node['fields']?['linkType'] ?? 'custom';

      dynamic internalLink = null;

      if (linkType == 'internal') {
        String? title = node['fields']?['doc']?['label'];
        int? id = node['fields']?['doc']?['value']?['id'];
        String? collection = getPageRoute(
          node['fields']?['doc']?['relationTo'],
        );

        if (title != null && id != null && collection != null) {
          internalLink = {
            'title': title,
            'id': id.toString(),
            'collection': collection,
          };
        }
      }

      final String? url = node['fields']?['url'];

      final tapRecognizer = TapGestureRecognizer()
        ..onTap = () {
          if (linkType == 'internal' && internalLink != null) {
            GoRouter.of(context).pushNamed(
              internalLink['collection'],
              pathParameters: {
                'id': internalLink['id'],
                'title': internalLink['title'],
              },
            );
          } else if (linkType == 'custom' && url != null) {
            // TODO: Add url_launcher package to open links
            launchUrl(Uri.parse(url));
            debugPrint('Link tapped: $url');
          }
        };

      return TextSpan(
        children: linkChildren.map((c) {
          final span = _buildSpan(c);
          if (span is TextSpan) {
            return TextSpan(
              text: span.text,
              style: (span.style ?? baseStyle ?? const TextStyle()).copyWith(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: tapRecognizer,
            );
          }
          return span;
        }).toList(),
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      );
    }

    if (type == 'text') {
      return TextSpan(
        text: node['text'],
        style: _getTextStyle(node['format'] ?? 0),
      );
    }

    return const TextSpan();
  }

  TextStyle _getTextStyle(int format) {
    // Lexical uses a bit mask to format text:
    // 1: bold, 2: italic, 4: strikethrough, 8: underline, 16: code, 32: subscript, 64: superscript

    bool isBold = (format & 1) != 0;
    bool isItalic = (format & 2) != 0;
    bool isStrikethrough = (format & 4) != 0;
    bool isUnderline = (format & 8) != 0;
    bool isCode = (format & 16) != 0;

    return TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: TextDecoration.combine([
        if (isStrikethrough) TextDecoration.lineThrough,
        if (isUnderline) TextDecoration.underline,
      ]),
      fontFamily: isCode ? 'monospace' : null,
      backgroundColor: isCode ? Colors.grey.shade200 : null,
    );
  }
}
