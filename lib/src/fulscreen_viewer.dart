import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:styled_widget/styled_widget.dart';

/// A widget that displays a full-screen image gallery with pagination and an app bar.
class FullScreenViewer extends HookWidget {
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
  Widget build(BuildContext context) {
    var textColor = Theme.of(context).colorScheme.onBackground;
    var currentPageIndex = useState(initialPage + 1);
    var pageController = PageController(initialPage: initialPage);

    // Disposes of the page controller when the widget is removed from the tree.
    useEffect(() => () => pageController.dispose());

    return Scaffold(
      bottomSheet: Styled.text(
        '${currentPageIndex.value}/${images.length}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor.withOpacity(0.7),
          fontSize: 16,
        ),
      ).width(double.infinity),
      appBar: AppBar(title: Text(title, textAlign: TextAlign.center)),
      body: PhotoViewGallery.builder(
        builder: (_, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(images[index]),
          );
        },
        pageController: pageController,
        itemCount: images.length,
        onPageChanged: (value) => currentPageIndex.value = value + 1,
      ),
    );
  }
}
