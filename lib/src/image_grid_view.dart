import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:image_grid_view/src/fulscreen_viewer.dart';
import 'package:image_grid_view/src/grid_image_item.dart';
import 'package:image_grid_view/src/last_item.dart';
import 'package:image_grid_view/src/presets.dart';
import 'package:styled_widget/styled_widget.dart';

/// A widget that displays a grid of images with an option to view the images full screen.
class ImageGridView extends HookWidget {
  /// Creates a grid of images with an option to view the images full screen.
  ///
  /// The `images` parameter is a list of URLs for the images to display. The `fullScreenTitle` parameter
  /// specifies the title to display in the app bar when an image is viewed full screen.
  const ImageGridView({
    Key? key,
    required this.images,
    required this.fullScreenTitle,
  }) : super(key: key);

  /// The URLs of the images to display in the grid.
  ///
  /// The maximum length of visible `images` in grid is 9.
  /// Other images will be displayed in the last item as counter.
  final List<String> images;

  /// The title to display in the app bar when an image is viewed full screen.
  final String fullScreenTitle;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container();
    }

    var mainImages = useState<List<String>>([]);
    var otherImages = useState<List<String>>([]);

    // Separates the list of images into two lists: `mainImages` and `otherImages`.
    useEffect(() {
      var delimiterIndex = images.length > 9 ? 9 : images.length;
      mainImages.value = images.sublist(0, delimiterIndex);

      if (images.length > delimiterIndex) {
        otherImages.value = images.sublist(delimiterIndex);
      }
      return null;
    }, [images]);

    return LayoutGrid(
      areas: presets[mainImages.value.length] ?? presets[1]!,
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      rowGap: 2.0,
      columnGap: 2.0,
      gridFit: GridFit.loose,
      children: mainImages.value.map((e) {
        var index = mainImages.value.indexOf(e);
        var url = mainImages.value[index];
        var isShowMore = index + 1 == mainImages.value.length &&
            otherImages.value.isNotEmpty;

        var element = isShowMore
            ? LastItem(count: otherImages.value.length, url: url)
            : GridImageItem(url: url);

        return element
            .width(double.infinity)
            .height(double.infinity)
            .gestures(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenViewer(
                    images: images,
                    initialPage: index,
                    title: fullScreenTitle,
                  ),
                ),
              ),
            )
            .inGridArea(gridPositionName[index]);
      }).toList(),
    );
  }
}

/// An enumeration of the types of `ImageAnimatedGrid`.
enum ImageAnimatedGridType { link }

/// Names for matching the grid positions.
const gridPositionName = [
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
];
