import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A widget that displays a single image within a grid.
class GridImageItem extends HookWidget {
  /// Creates a widget to display a single image in a grid.
  ///
  /// The `url` parameter is the URL of the image to display.
  const GridImageItem({
    Key? key,
    required this.url,
  }) : super(key: key);

  /// The URL of the image to display.
  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
