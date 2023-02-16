import 'package:flutter/material.dart';
import 'package:image_grid_view/src/grid_image_item.dart';

/// A widget that displays the last item in a grid of images, along with a count of any additional images.
class LastItem extends StatelessWidget {
  /// Creates a widget to display the last item in a grid of images.
  ///
  /// The `count` parameter is the number of additional images that are not displayed in the grid.
  /// The `url` parameter is the URL of the last image displayed in the grid.
  const LastItem({Key? key, required this.count, required this.url})
      : super(key: key);

  /// The number of additional images that are not displayed in the grid.
  final int count;

  /// The URL of the last image displayed in the grid.
  final String url;

  @override
  Widget build(BuildContext context) {
    var textColor = Theme.of(context).colorScheme.onBackground;
    var backgroundColor = Theme.of(context).colorScheme.background;

    return Stack(children: [
      Container(
        child: GridImageItem(url: url),
        height: double.infinity,
        width: double.infinity,
      ),
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: backgroundColor.withOpacity(0.5)),
        child: Center(
          child: Text(
            '+$count',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    ]);
  }
}
