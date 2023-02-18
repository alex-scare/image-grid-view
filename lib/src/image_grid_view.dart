import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:image_grid_view/src/fulscreen_viewer.dart';
import 'package:image_grid_view/src/grid_image_item.dart';
import 'package:image_grid_view/src/last_item.dart';
import 'package:image_grid_view/src/presets.dart';

class ImageGridGestures {
  ImageGridGestures({this.onTap, this.onLongPress, this.onDoubleTap});

  final Function(String image)? onTap;
  final Function(String image)? onLongPress;
  final Function(String image)? onDoubleTap;
}

class ImageGridStyle {
  ImageGridStyle({this.gap = 2.0});

  final double gap;
}

/// A widget that displays a grid of images with an option to view the images full screen.
class ImageGridView extends StatefulWidget {
  /// Creates a grid of images with an option to view the images full screen.
  ///
  /// The `images` parameter is a list of URLs for the images to display. The `fullScreenTitle` parameter
  /// specifies the title to display in the app bar when an image is viewed full screen.
  ImageGridView({
    Key? key,
    required this.images,
    this.fullScreenTitle = '',
    this.enableFullScreen = true,
    this.imageGestures,
    this.imageStyle,
  }) : super(key: key);

  /// The URLs of the images to display in the grid.
  ///
  /// The maximum length of visible `images` in grid is 9.
  /// Other images will be displayed in the last item as counter.
  final List<String> images;

  /// The title to display in the app bar when an image is viewed full screen.
  final String fullScreenTitle;

  /// Open images in fullscreen gallery via tap or not
  final bool enableFullScreen;

  final ImageGridGestures? imageGestures;

  final ImageGridStyle? imageStyle;

  @override
  State<ImageGridView> createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  List<String> mainImages = [];
  List<String> otherImages = [];
  ImageGridStyle imageStyle = ImageGridStyle();

  @override
  void initState() {
    var delimiterIndex = widget.images.length > 9 ? 9 : widget.images.length;
    mainImages = widget.images.sublist(0, delimiterIndex);

    if (widget.images.length > delimiterIndex) {
      otherImages = widget.images.sublist(delimiterIndex);
    }

    if (widget.imageStyle != null) imageStyle = widget.imageStyle!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container();
    }

    return LayoutGrid(
      areas: presets[mainImages.length] ?? presets[1]!,
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      rowSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
      rowGap: imageStyle.gap,
      columnGap: imageStyle.gap,
      gridFit: GridFit.loose,
      children: mainImages.map((image) => _buildImage(context, image)).toList(),
    );
  }

  Widget _buildImage(BuildContext context, String image) {
    var index = mainImages.indexOf(image);
    var url = mainImages[index];
    var isLastImage = index + 1 == mainImages.length;

    var element = otherImages.isNotEmpty && isLastImage
        ? LastItem(count: otherImages.length, url: url)
        : GridImageItem(url: url);

    return GestureDetector(
      onTap: () {
        if (widget.enableFullScreen) openFullscreen(context, index);
        widget.imageGestures?.onTap?.call(image);
      },
      onLongPress: () => widget.imageGestures?.onLongPress?.call(image),
      onDoubleTap: () => widget.imageGestures?.onDoubleTap?.call(image),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: element,
      ),
    ).inGridArea(gridPositionName[index]);
  }

  openFullscreen(BuildContext context, int index) {
    final fullScreenRoute = FullScreenViewer(
      images: widget.images,
      initialPage: index,
      title: widget.fullScreenTitle,
    );

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => fullScreenRoute));
  }
}

/// An enumeration of the types of `ImageAnimatedGrid`.
enum ImageAnimatedGridType { link }
