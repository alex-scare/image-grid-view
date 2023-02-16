import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:styled_widget/styled_widget.dart';

/// A widget that displays a full-screen image gallery with pagination and an app bar.
class FullScreenViewer extends StatefulWidget {
  /// Creates a full-screen image gallery.
  ///
  /// The `initialPage` parameter specifies the initial image to display in the gallery. The `images` parameter
  /// is a list of URLs for the images to display. The `title` parameter specifies the title to display in the app bar.
  const FullScreenViewer({
    Key? key,
    this.initialPage = 1,
    required this.images,
    required this.title,
  }) : super(key: key);

  /// The initial page to display in the gallery.
  final int initialPage;

  /// The URLs of the images to display in the gallery.
  final List<String> images;

  /// The title to display in the app bar.
  final String title;

  @override
  State<FullScreenViewer> createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<FullScreenViewer> {
  int currentPageIndex = 0;

  PageController? pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialPage);
    currentPageIndex = widget.initialPage + 1;

    super.initState();
  }

  @override
  void dispose() {
    pageController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      bottomSheet: Styled.text(
        '$currentPageIndex/${widget.images.length}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor.withOpacity(0.7),
          fontSize: 16,
        ),
      ).width(double.infinity),
      appBar: AppBar(title: Text(widget.title, textAlign: TextAlign.center)),
      body: PhotoViewGallery.builder(
          builder: (_, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.images[index]),
            );
          },
          pageController: pageController,
          itemCount: widget.images.length,
          onPageChanged: (value) {
            setState(() {
              currentPageIndex = value + 1;
            });
          }),
    );
  }
}
